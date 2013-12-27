From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: spinlock_irqsave() && flags (Was: pm80xx: Spinlock fix)
Date: Fri, 27 Dec 2013 17:18:02 +0100
Message-ID: <20131227161802.GA21077@redhat.com>
References: <CAD0Z9T+69VoSnDY-Sj7a1QfJ-KLJYVyL9=WQ123XMfRvQmGdsg@mail.gmail.com> <52B8518B.4060204@gmail.com> <52B8569D.4050101@redhat.com> <CAD0Z9TK-cn=X3ywSzPnEQN-FB+ue+0dHQ3EHuwonC+KfgrmPMA@mail.gmail.com> <20131223163410.GA28220@redhat.com> <20131223172744.GA2069@redhat.com> <20131223182323.GA8656@gmail.com> <20131223183341.GA6082@redhat.com> <20131224082931.GA20471@gmail.com> <CE2C58F938F4C44EA74FFF880BAA7E5E1C68AD12@BBYEXM01.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CE2C58F938F4C44EA74FFF880BAA7E5E1C68AD12@BBYEXM01.pmc-sierra.internal>
Sender: linux-kernel-owner@vger.kernel.org
To: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
Cc: Ingo Molnar <mingo@kernel.org>, Jason Seba <jason.seba42@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Tomas Henzl <thenzl@redhat.com>, Jack Wang <xjtuwjp@gmail.com>, Viswas G <Viswas.G@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>, Vasanthalakshmi Tharmarajan <Vasanthalakshmi.Tharmarajan@pmcs.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 12/24, Suresh Thiagarajan wrote:
>
> Below is a small pseudo code on protecting/serializing the flag for global access.
> struct temp
> {
> 	...
> 	spinlock_t lock;
> 	unsigned long lock_flags;
> };
> void my_lock(struct temp *t)
> {
>                unsigned long flag; // thread-private variable as suggested
>                spin_lock_irqsave(&t->lock, flag);
>                t->lock_flags = flag; //updating inside critical section now to serialize the access to flag
> }
>
> void my_unlock(struct temp *t)
> {
>                unsigned long flag = t->lock_flags;
>                t->lock_flags = 0;  //clearing it before getting out of critical section
>                spin_unlock_irqrestore(&t->lock, flag);
> }

Yes, this should work as a quick fix. And you do not need to clear ->lock_flags
in my_unlock().

But when I look at original patch again, I no longer understand why do
you need pm8001_ha->lock_flags at all. Of course I do not understand this
code, I am sure I missed something, but at first glance it seems that only
this sequence

	spin_unlock_irq(&pm8001_ha->lock);
	t->task_done(t);
	spin_lock_irq(&pm8001_ha->lock);

should be fixed?

If yes, why you can't simply do spin_unlock() + spin_lock() around
t->task_done() ? This won't enable irqs, but spin_unlock_irqrestore()
doesn't necessarily enables irqs too, so ->task_done() can run with
irqs disabled?

And note that the pattern above has a lot of users, perhaps it makes
sense to start with something like the patch below?

Hmm. there is another oddity in this code, for example mpi_sata_completion()
does

	} else if (t->uldd_task) {
		spin_unlock_irqrestore(&t->task_state_lock, flags);
		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
		mb();/* ditto */
		spin_unlock_irq(&pm8001_ha->lock);
		t->task_done(t);
		spin_lock_irq(&pm8001_ha->lock);
	} else if (!t->uldd_task) {
		spin_unlock_irqrestore(&t->task_state_lock, flags);
		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
		mb();/*ditto*/
		spin_unlock_irq(&pm8001_ha->lock);
		t->task_done(t);
		spin_lock_irq(&pm8001_ha->lock);
	}

and both branches do the same code? mpi_sata_event(), pm8001_chip_sata_req()
too.

Imho, whatever you do, the changelog should tell more.

Oleg.


--- x/drivers/scsi/pm8001/pm8001_sas.h
+++ x/drivers/scsi/pm8001/pm8001_sas.h
@@ -619,6 +619,20 @@ u32 pm8001_get_ncq_tag(struct sas_task *
 void pm8001_ccb_free(struct pm8001_hba_info *pm8001_ha, u32 ccb_idx);
 void pm8001_ccb_task_free(struct pm8001_hba_info *pm8001_ha,
 	struct sas_task *task, struct pm8001_ccb_info *ccb, u32 ccb_idx);
+
+static inline void
+pm8001_ccb_task_free_done(struct pm8001_hba_info *pm8001_ha,
+			struct sas_task *task, struct pm8001_ccb_info *ccb,
+			u32 ccb_idx)
+{
+	pm8001_ccb_task_free(pm8001_ha, task, ccb, ccb_idx);
+	smp_mb(); /* comment */
+	spin_unlock(&pm8001_ha->lock);
+	task->task_done(task);
+	spin_lock(&pm8001_ha->lock);
+}
+
+
 int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 	void *funcdata);
 void pm8001_scan_start(struct Scsi_Host *shost);
--- x/drivers/scsi/pm8001/pm8001_hwi.c
+++ x/drivers/scsi/pm8001/pm8001_hwi.c
@@ -2502,11 +2502,7 @@ mpi_sata_completion(struct pm8001_hba_in
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 			ts->resp = SAS_TASK_UNDELIVERED;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-			mb();/*in order to force CPU ordering*/
-			spin_unlock_irq(&pm8001_ha->lock);
-			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 			return;
 		}
 		break;
@@ -2522,11 +2518,7 @@ mpi_sata_completion(struct pm8001_hba_in
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 			ts->resp = SAS_TASK_UNDELIVERED;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-			mb();/*ditto*/
-			spin_unlock_irq(&pm8001_ha->lock);
-			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 			return;
 		}
 		break;
@@ -2550,11 +2542,7 @@ mpi_sata_completion(struct pm8001_hba_in
 				IO_OPEN_CNX_ERROR_STP_RESOURCES_BUSY);
 			ts->resp = SAS_TASK_UNDELIVERED;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-			mb();/* ditto*/
-			spin_unlock_irq(&pm8001_ha->lock);
-			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 			return;
 		}
 		break;
@@ -2617,11 +2605,7 @@ mpi_sata_completion(struct pm8001_hba_in
 				    IO_DS_NON_OPERATIONAL);
 			ts->resp = SAS_TASK_UNDELIVERED;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-			mb();/*ditto*/
-			spin_unlock_irq(&pm8001_ha->lock);
-			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 			return;
 		}
 		break;
@@ -2641,11 +2625,7 @@ mpi_sata_completion(struct pm8001_hba_in
 				    IO_DS_IN_ERROR);
 			ts->resp = SAS_TASK_UNDELIVERED;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-			mb();/*ditto*/
-			spin_unlock_irq(&pm8001_ha->lock);
-			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 			return;
 		}
 		break;
@@ -2674,20 +2654,9 @@ mpi_sata_completion(struct pm8001_hba_in
 			" resp 0x%x stat 0x%x but aborted by upper layer!\n",
 			t, status, ts->resp, ts->stat));
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-	} else if (t->uldd_task) {
-		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-		mb();/* ditto */
-		spin_unlock_irq(&pm8001_ha->lock);
-		t->task_done(t);
-		spin_lock_irq(&pm8001_ha->lock);
-	} else if (!t->uldd_task) {
+	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-		mb();/*ditto*/
-		spin_unlock_irq(&pm8001_ha->lock);
-		t->task_done(t);
-		spin_lock_irq(&pm8001_ha->lock);
+		pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 	}
 }
 
@@ -2796,11 +2765,7 @@ static void mpi_sata_event(struct pm8001
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 			ts->resp = SAS_TASK_COMPLETE;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-			mb();/*ditto*/
-			spin_unlock_irq(&pm8001_ha->lock);
-			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 			return;
 		}
 		break;
@@ -2909,20 +2874,9 @@ static void mpi_sata_event(struct pm8001
 			" resp 0x%x stat 0x%x but aborted by upper layer!\n",
 			t, event, ts->resp, ts->stat));
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-	} else if (t->uldd_task) {
-		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-		mb();/* ditto */
-		spin_unlock_irq(&pm8001_ha->lock);
-		t->task_done(t);
-		spin_lock_irq(&pm8001_ha->lock);
-	} else if (!t->uldd_task) {
+	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-		mb();/*ditto*/
-		spin_unlock_irq(&pm8001_ha->lock);
-		t->task_done(t);
-		spin_lock_irq(&pm8001_ha->lock);
+		pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 	}
 }
 
@@ -4467,23 +4421,10 @@ static int pm8001_chip_sata_req(struct p
 					" stat 0x%x but aborted by upper layer "
 					"\n", task, ts->resp, ts->stat));
 				pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
-			} else if (task->uldd_task) {
-				spin_unlock_irqrestore(&task->task_state_lock,
-							flags);
-				pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
-				mb();/* ditto */
-				spin_unlock_irq(&pm8001_ha->lock);
-				task->task_done(task);
-				spin_lock_irq(&pm8001_ha->lock);
-				return 0;
-			} else if (!task->uldd_task) {
+			} else {
 				spin_unlock_irqrestore(&task->task_state_lock,
 							flags);
-				pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
-				mb();/*ditto*/
-				spin_unlock_irq(&pm8001_ha->lock);
-				task->task_done(task);
-				spin_lock_irq(&pm8001_ha->lock);
+				pm8001_ccb_task_free_done(pm8001_ha, task, ccb, tag);
 				return 0;
 			}
 		}
--- x/drivers/scsi/pm8001/pm80xx_hwi.c
+++ x/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -2175,11 +2175,7 @@ mpi_sata_completion(struct pm8001_hba_in
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 			ts->resp = SAS_TASK_UNDELIVERED;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-			mb();/*in order to force CPU ordering*/
-			spin_unlock_irq(&pm8001_ha->lock);
-			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 			return;
 		}
 		break;
@@ -2195,11 +2191,7 @@ mpi_sata_completion(struct pm8001_hba_in
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 			ts->resp = SAS_TASK_UNDELIVERED;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-			mb();/*ditto*/
-			spin_unlock_irq(&pm8001_ha->lock);
-			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 			return;
 		}
 		break;
@@ -2221,11 +2213,7 @@ mpi_sata_completion(struct pm8001_hba_in
 				IO_OPEN_CNX_ERROR_STP_RESOURCES_BUSY);
 			ts->resp = SAS_TASK_UNDELIVERED;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-			mb();/* ditto*/
-			spin_unlock_irq(&pm8001_ha->lock);
-			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 			return;
 		}
 		break;
@@ -2288,11 +2276,7 @@ mpi_sata_completion(struct pm8001_hba_in
 					IO_DS_NON_OPERATIONAL);
 			ts->resp = SAS_TASK_UNDELIVERED;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-			mb();/*ditto*/
-			spin_unlock_irq(&pm8001_ha->lock);
-			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 			return;
 		}
 		break;
@@ -2312,11 +2296,7 @@ mpi_sata_completion(struct pm8001_hba_in
 					IO_DS_IN_ERROR);
 			ts->resp = SAS_TASK_UNDELIVERED;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-			mb();/*ditto*/
-			spin_unlock_irq(&pm8001_ha->lock);
-			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 			return;
 		}
 		break;
@@ -2345,20 +2325,9 @@ mpi_sata_completion(struct pm8001_hba_in
 			" resp 0x%x stat 0x%x but aborted by upper layer!\n",
 			t, status, ts->resp, ts->stat));
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-	} else if (t->uldd_task) {
-		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-		mb();/* ditto */
-		spin_unlock_irq(&pm8001_ha->lock);
-		t->task_done(t);
-		spin_lock_irq(&pm8001_ha->lock);
-	} else if (!t->uldd_task) {
+	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-		mb();/*ditto*/
-		spin_unlock_irq(&pm8001_ha->lock);
-		t->task_done(t);
-		spin_lock_irq(&pm8001_ha->lock);
+		pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 	}
 }
 
@@ -2470,11 +2439,7 @@ static void mpi_sata_event(struct pm8001
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 			ts->resp = SAS_TASK_COMPLETE;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-			mb();/*ditto*/
-			spin_unlock_irq(&pm8001_ha->lock);
-			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 			return;
 		}
 		break;
@@ -2596,20 +2561,9 @@ static void mpi_sata_event(struct pm8001
 			" resp 0x%x stat 0x%x but aborted by upper layer!\n",
 			t, event, ts->resp, ts->stat));
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-	} else if (t->uldd_task) {
-		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-		mb();/* ditto */
-		spin_unlock_irq(&pm8001_ha->lock);
-		t->task_done(t);
-		spin_lock_irq(&pm8001_ha->lock);
-	} else if (!t->uldd_task) {
+	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-		mb();/*ditto*/
-		spin_unlock_irq(&pm8001_ha->lock);
-		t->task_done(t);
-		spin_lock_irq(&pm8001_ha->lock);
+		pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 	}
 }
 
@@ -4304,23 +4258,10 @@ static int pm80xx_chip_sata_req(struct p
 					"\n", task, ts->resp, ts->stat));
 				pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
 				return 0;
-			} else if (task->uldd_task) {
-				spin_unlock_irqrestore(&task->task_state_lock,
-							flags);
-				pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
-				mb();/* ditto */
-				spin_unlock_irq(&pm8001_ha->lock);
-				task->task_done(task);
-				spin_lock_irq(&pm8001_ha->lock);
-				return 0;
-			} else if (!task->uldd_task) {
+			} else {
 				spin_unlock_irqrestore(&task->task_state_lock,
 							flags);
-				pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
-				mb();/*ditto*/
-				spin_unlock_irq(&pm8001_ha->lock);
-				task->task_done(task);
-				spin_lock_irq(&pm8001_ha->lock);
+				pm8001_ccb_task_free_done(pm8001_ha, task, ccb, tag);
 				return 0;
 			}
 		}
