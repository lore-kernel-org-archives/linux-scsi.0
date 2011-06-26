From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 1/3] PM / Runtime: Update documentation of
	interactions with system sleep
Date: Sun, 26 Jun 2011 22:12:19 +0200
Message-ID: <201106262212.19348.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1106252257440.10907-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-bounces@lists.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.1106252257440.10907-100000@netrider.rowland.org>
List-Unsubscribe: <https://lists.linux-foundation.org/mailman/listinfo/linux-pm>,
	<mailto:linux-pm-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linux-foundation.org/pipermail/linux-pm>
List-Post: <mailto:linux-pm@lists.linux-foundation.org>
List-Help: <mailto:linux-pm-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linux-foundation.org/mailman/listinfo/linux-pm>,
	<mailto:linux-pm-request@lists.linux-foundation.org?subject=subscribe>
Sender: linux-pm-bounces@lists.linux-foundation.org
Errors-To: linux-pm-bounces@lists.linux-foundation.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>, Jesper Juhl <jj@chaosbits.net>, Tejun Heo <tj@kernel.org>, Linux PM mailing list <linux-pm@lists.linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Sunday, June 26, 2011, Alan Stern wrote:
> On Sun, 26 Jun 2011, Jesper Juhl wrote:
> 
> > On Sun, 26 Jun 2011, Rafael J. Wysocki wrote:
> > 
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > 
> > A few tiny nit-picks..
> 
> And a few more...
> 
> > > The documents describing the interactions between runtime PM and
> > > system sleep generally refer to the model in which the system sleep
> > > state is entered through a global firmware or hardware operation.
> > > As a result, some recommendations given in there are not entirely
> > > suitable for systems in which this is not the case.  Update the
> > > documentation take the existence of those systems into accout.
> > > 
> > 
> > I believe this should read "... documentation to take the existence of 
> > those systems ..."
> 
> Also add the missing 'n' in "account".

Thanks, updated patch is appended.

Apparently, I'm not good at writing changelogs late in the night.

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Runtime: Update documentation of interactions with system sleep

The documents describing the interactions between runtime PM and
system sleep generally refer to the model in which the system sleep
state is entered through a global firmware or hardware operation.
As a result, some recommendations given in there are not entirely
suitable for systems in which this is not the case.  Update the
documentation to take the existence of those systems into account.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reviewed-by: Kevin Hilman <khilman@ti.com>
---
 Documentation/power/devices.txt    |    6 +++---
 Documentation/power/runtime_pm.txt |   27 +++++++++++++++++++--------
 2 files changed, 22 insertions(+), 11 deletions(-)

Index: linux-2.6/Documentation/power/runtime_pm.txt
===================================================================
--- linux-2.6.orig/Documentation/power/runtime_pm.txt
+++ linux-2.6/Documentation/power/runtime_pm.txt
@@ -537,9 +537,9 @@ suspend routine).  It may be necessary t
 in order to do so.  The same is true if the driver uses different power levels
 or other settings for run-time suspend and system sleep.
 
-During system resume, devices generally should be brought back to full power,
-even if they were suspended before the system sleep began.  There are several
-reasons for this, including:
+During system resume, the simplest approach is to bring all devices back to full
+power, even if they had been suspended before the system suspend began.  There
+are several reasons for this, including:
 
   * The device might need to switch power levels, wake-up settings, etc.
 
@@ -556,16 +556,27 @@ reasons for this, including:
   * Even though the device was suspended, if its usage counter was > 0 then most
     likely it would need a run-time resume in the near future anyway.
 
-  * Always going back to full power is simplest.
-
-If the device was suspended before the sleep began, then its run-time PM status
-will have to be updated to reflect the actual post-system sleep status.  The way
-to do this is:
+If the device had been suspended before the system suspend began and it's
+brought back to full power during resume, then its run-time PM status will have
+to be updated to reflect the actual post-system sleep status.  The way to do
+this is:
 
 	pm_runtime_disable(dev);
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
 
+On some systems, however, system sleep is not entered through a global firmware
+or hardware operation.  Instead, all hardware components are put into low-power
+states directly by the kernel in a coordinated way.  Then, the system sleep
+state effectively follows from the states the hardware components end up in
+and the system is woken up from that state by a hardware interrupt or a similar
+mechanism entirely under the kernel's control.  As a result, the kernel never
+gives control away and the states of all devices during resume are precisely
+known to it.  If that is the case and none of the situations listed above takes
+place (in particular, if the system is not waking up from hibernation), it may
+be more efficient to leave the devices that had been suspended before the system
+suspend began in the suspended state.
+
 7. Generic subsystem callbacks
 
 Subsystems may wish to conserve code space by using the set of generic power
Index: linux-2.6/Documentation/power/devices.txt
===================================================================
--- linux-2.6.orig/Documentation/power/devices.txt
+++ linux-2.6/Documentation/power/devices.txt
@@ -604,7 +604,7 @@ state temporarily, for example so that i
 disabled.  This all depends on the hardware and the design of the subsystem and
 device driver in question.
 
-During system-wide resume from a sleep state it's best to put devices into the
-full-power state, as explained in Documentation/power/runtime_pm.txt.  Refer to
-that document for more information regarding this particular issue as well as
+During system-wide resume from a sleep state it's easiest to put devices into
+the full-power state, as explained in Documentation/power/runtime_pm.txt.  Refer
+to that document for more information regarding this particular issue as well as
 for information on the device runtime power management framework in general.
