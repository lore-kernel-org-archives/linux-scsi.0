From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 2/3] lpfc: fix misleading indentation
Date: Mon, 14 Mar 2016 11:48:03 -0400
Message-ID: <1457970483.4188.19.camel@localhost.localdomain>
References: <1457965789-3373916-1-git-send-email-arnd@arndb.de>
	 <1457965789-3373916-3-git-send-email-arnd@arndb.de>
	 <56E6D69E.1050008@suse.de> <13330994.pIJCLN5xX1@wuerfel>
	 <56E6D824.3080809@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56E6D824.3080809@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>, martin.petersen@oracle.com, James.Bottomley@hansenpartnership.com, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Sebastian Herbszt <herbszt@gmx.de>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2016-03-14 at 16:26 +0100, Hannes Reinecke wrote:
> On 03/14/2016 04:25 PM, Arnd Bergmann wrote:
> > On Monday 14 March 2016 16:19:58 Hannes Reinecke wrote:
> >>>       vports = lpfc_create_vport_work_array(phba);
> >>> -     if (vports != NULL)
> >>> +     if (vports != NULL) {
> >>>               for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
> >>>                       struct Scsi_Host *shost;
> >>>                       shost = lpfc_shost_from_vport(vports[i]);
> >>> @@ -2877,7 +2877,8 @@ lpfc_online(struct lpfc_hba *phba)
> >>>                       }
> >>>                       spin_unlock_irq(shost->host_lock);
> >>>               }
> >>> -             lpfc_destroy_vport_work_array(phba, vports);
> >>> +     }
> >>> +     lpfc_destroy_vport_work_array(phba, vports);
> >>>  
> >>>       lpfc_unblock_mgmt_io(phba);
> >>>       return 0;
> >>>
> >> Nope.
> >>
> >> vports is only valid from within the indentation block, so it should
> >> be moved into it.
> >>
> >>
> > 
> > Well, every other user of the function also looks like
> > 
> > 	vports = lpfc_create_vport_work_array(phba);
> > 	if (vports != NULL) {
> > 		do_something(vports);
> > 	}
> > 	lpfc_destroy_vport_work_array(phba, vports);

Actually the lpfc code is inconsistent about whether the _destroy call
is within the (vports != NULL) test or not, but as you say below it
doesn't matter.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

> > 
> > and lpfc_destroy_vport_work_array() does nothing if its argument is NULL.
> > 
> > I still think my patch is the correct fix for the warning.
> > 
> Okay, good point.
> 
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> 
> Cheers,
> 
> Hannes
