From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 00/44] Convert FibreChannel bsg code to use bsg-lib
Date: Tue, 11 Oct 2016 20:00:58 +0200
Message-ID: <57FD28DA.703@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 10/11/2016 01:28 PM, Johannes Thumshirn wrote:
> This series converts the current bsg usage in the FibreChannel drivers over
> to use bsg-lib. SAS will follow but 44 patches are big enough for one shot,
> so I didn't want to include SAS in there as well.
>
> It looks a bit huge but most of the patches are only code movement and slow
> API conversions so everything still works and builds when doing git bisects.
>
> I did take some inspiration from a similar patchset from Mike Christie
> dating back to 2011 but it's not a 1:1 copy. Patch 43/44 is heavily based
> on his series and attribution is given to him in the commit message.
>
> It is currently regression tested on FCoE using the 'fcns' and
> 'fcrls'utilities.  I'm still trying to figure out how to test the other
> LLDDs. So any pointer from the respective maintainers are appreciated
> although the LLDD changes are purely mechanical. All they do is change from
> 'struct fc_bsg_job' to 'struct bsg_job' and corresponding changes in order
> to get the series bisectable.
>
> The idea for this change arose when discussing racy sysfs handling the FC
> bsg code with Christoph and is a next step in moving all bsg clients to
> bsg-lib to eventually clean up the in kernel bsg API.
>
> Johannes Thumshirn (44):
>    scsi: Get rid of struct fc_bsg_buffer

>    bfa: don't use fc_bsg_job::request and fc_bsg_job::reply directly
>    zfcp: don't use fc_bsg_job::request and fc_bsg_job::reply directly
>    ibmvfc: don't use fc_bsg_job::request and fc_bsg_job::reply directly
>    lpfc: don't use fc_bsg_job::request and fc_bsg_job::reply directly
>    qla2xxx: don't use fc_bsg_job::request and fc_bsg_job::reply directly
>    libfc: don't use fc_bsg_job::request and fc_bsg_job::reply directly
>    scsi: fc: don't use fc_bsg_job::request and fc_bsg_job::reply directly
Please merge these in a single patch.
You do a similar thing later (in the patch 'change FC drivers to use 
'struct bsg_job''), so there's no need to have them a separate patches here.

>    scsi: fc: Export fc_bsg_jobdone
>    zfcp: Use fc_bsg_jobdone()
>    bfa: Use fc_bsg_jobdone()
>    ibmvfc: Use fc_bsg_jobdone()
>    libfc: Use fc_bsg_jobdone()
>    lpfc: Use fc_bsg_jobdone()
>    qla2xxx: Use fc_bsg_jobdone()
Same for these patches

>    scsi: fc: remove job_done method from struct fc_bsg_job
>    scsi: Unify interfaces of fc_bsg_jobdone and bsg_job_done
>    scsi: fc: provide fc_bsg_to_shost() helper
>    scsi: fc: use fc_bsg_to_shost() to access a bsg_job's Scsi_Host
>    bfa: use fc_bsg_to_shost() to access a bsg_job's Scsi_Host
>    lpfc: use fc_bsg_to_shost() to access a bsg_job's Scsi_Host
>    qla2xxx: use fc_bsg_to_shost() to access a bsg_job's Scsi_Host
>    libfc: use fc_bsg_to_shost() to access a bsg_job's Scsi_Host
>    ibmvfc: use fc_bsg_to_shost() to access a bsg_job's Scsi_Host
>    zfcp: use fc_bsg_to_shost() to access a bsg_job's Scsi_Host
And these

>    scsi: fc: provide fc_bsg_to_rport() helper
>    scsi: fc: use fc_bsg_to_rport() to access a bsg_job's rport
>    zfcp: use fc_bsg_to_rport() to access a bsg_job's rport
>    qla2xxx: use fc_bsg_to_rport() to access a bsg_job's rport
>    lpfc: use fc_bsg_to_rport() to access a bsg_job's rport
>    libfc: use fc_bsg_to_rport() to access a bsg_job's rport
>    ibmvfc: use fc_bsg_to_rport() to access a bsg_job's rport
And these.

That should cut down the number of patches by quite a bit.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
