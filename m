From: "invictus rm" <invictus_rm@hotmail.com>
Subject: Re: scsi wait_for_completion hangs!!!
Date: Fri, 22 Aug 2003 15:55:53 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <BAY7-F93CaO9smko29f00034267@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bay7-f93.bay7.hotmail.com ([64.4.11.93]:20745 "EHLO hotmail.com")
	by vger.kernel.org with ESMTP id S263071AbTHVKZy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2003 06:25:54 -0400
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: linux-scsi@vger.kernel.org

hi,
  Tx for the reply
  I am attaching the relevant portions of the driver which deals with SCSI 
interaction::

#include "/usr/src/linux/drivers/scsi/scsi.h"
#include "/usr/src/linux/drivers/scsi/hosts.h"

#define SCSIHBA_CAN_QUEUE               1


#define SCSIHBA {                                               \
        name:                   " SCSI  HBA",                   \
        detect:                 scsihba_detect,                 \
        release:                scsihba_release,                        \
        info:                   scsihba_info,                   \
        queuecommand:           scsihba_scsi_queuecommand,      \
        can_queue:              SCSIHBA_CAN_QUEUE,              \
        this_id:                -1,                             \
        sg_tablesize:           1,                              \
        cmd_per_lun:            1,                              \
        use_clustering:         DISABLE_CLUSTERING,             \
        eh_abort_handler:       scsihba_scsi_abort,          \
        eh_device_reset_handler:NULL,                           \
        eh_bus_reset_handler:   NULL,                           \
        eh_host_reset_handler:  NULL,                           \
}


int scsihba_detect(Scsi_Host_Template *);
int scsihba_release(struct Scsi_Host *);
const char * scsihba_info(struct Scsi_Host *);
int scsihba_scsi_queuecommand(Scsi_Cmnd *, void (* done)(Scsi_Cmnd *));
int scsihba_scsi_abort(Scsi_Cmnd *);

int scsihba_scsi_queuecommand(Scsi_Cmnd *SCpnt, void (* done)(Scsi_Cmnd *))
{
        SCpnt->done = done;

        // Frame the packets and send to the hardware

        return 0;
}


int scsihba_scsi_abort(Scsi_Cmnd *SCpnt)
{
        SCpnt->result = DID_ABORT;
        printk("scsihba_scsi_abort..\n");
        return SUCCESS;
}

int __init scsihba_detect(Scsi_Host_Template *tpnt)
{
        struct Scsi_Host *host;

        tpnt->proc_name = "scsihba_hba";
        host = scsi_register (tpnt, sizeof(struct scsihba_host));
        if (!host)
        {
                printk("scsi_register fails ...\n");
        }

        host->max_id = 2;
        host->hostt->use_new_eh_code = 1;
        host->this_id = tpnt->this_id;

        return 1;
}

int scsihba_release(struct Scsi_Host *host)
{
        return 0;
}

const char *scsihba_info(struct Scsi_Host *host)
{
        static char buf[80];
        sprintf(buf,"SCSI Adapter...\n");
        return buf;
}

void my_callback_function(void *data)
{
        // Get the Scsi Command from the data
        (*SCpnt->scsi_done)(SCpnt);

}
static Scsi_Host_Template driver_template = SCSIHBA;

#include "/usr/src/linux/drivers/scsi/scsi_module.c"

-----------------------------------------------------------
-----------------------------------------------------------

Hope this will help to figure out the problem
Tx again for the help




>From: Christoph Hellwig <hch@infradead.org>
>To: invictus rm <invictus_rm@hotmail.com>
>CC: linux-scsi@vger.kernel.org
>Subject: Re: scsi wait_for_completion hangs!!!
>Date: Fri, 22 Aug 2003 10:53:03 +0100
>
>On Fri, Aug 22, 2003 at 03:18:06PM +0530, invictus rm wrote:
> > hi ,
> >     I am trying to write a HBA driver for a  PCI SCSI card(linux - 2.4.7 
>).
> >
> >    On insmoding the driver( after enabling scsi verbose logging) i was 
>able
> > to trace the point at which it get stuck.
>
>2.4.7 is obsolete.  IF it still happens with 2.4.21 please post the
>affected driver source so we can take a look what you're doing wrong.
>

_________________________________________________________________
ICICI's NRI services. They make life easy. 
http://server1.msn.co.in/msnspecials/nriservices/index.asp Find out more.

