From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: RE: [PATCH v2] scsi: mpt3sas: fix oops in error handlers after shutdown/unload
Date: Thu, 15 Feb 2018 11:18:21 +0530
Message-ID: <91f269efc5383e1d946f1ab793ad046b@mail.gmail.com>
References: <1517523386-9868-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <2fd5c995219c5e07ef04765f67b9b8a7@mail.gmail.com> <c2d58b10-b927-4a06-5edf-69f9fdb05bbd@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pl0-f43.google.com ([209.85.160.43]:36632 "EHLO
        mail-pl0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751067AbeBOFsY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Feb 2018 00:48:24 -0500
Received: by mail-pl0-f43.google.com with SMTP id v3so9885835plg.3
        for <linux-scsi@vger.kernel.org>; Wed, 14 Feb 2018 21:48:24 -0800 (PST)
In-Reply-To: <c2d58b10-b927-4a06-5edf-69f9fdb05bbd@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Bart.VanAssche@wdc.com
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, dougmill@linux.vnet.ibm.com

Mauricio,

During the shutdown time, I don't want the outstanding IOs to timeout due to
disabling of interrupts and go the TM path. So I wanted to clear out all the
Outstanding IOs in the shutdown path itself instead of clearing them in TM
path.

But if there are already some TMs are outstanding while initiating the
shutdown operation then your patch looks good to me.

May be can you include my set of changes along with your solution?

Thanks,
Sreekanth

-----Original Message-----
From: Mauricio Faria de Oliveira [mailto:mauricfo@linux.vnet.ibm.com]
Sent: Wednesday, February 14, 2018 9:05 PM
To: Sreekanth Reddy; linux-scsi@vger.kernel.org; Bart.VanAssche@wdc.com
Cc: Sathya Prakash Veerichetty; Chaitra Basappa; Suganath Prabu Subramani;
jejb@linux.vnet.ibm.com; martin.petersen@oracle.com;
dougmill@linux.vnet.ibm.com
Subject: Re: [PATCH v2] scsi: mpt3sas: fix oops in error handlers after
shutdown/unload

Hi Sreenkanth,

Thanks for reviewing.

On 02/12/2018 04:28 AM, Sreekanth Reddy wrote:
> Instead of returning the scmd with DID_NO_CONNECT in TM path, can we
> wait for some time (10 seconds) in shutdown/unload path for the
> outstanding commands to complete and even then [if] the scmds are
> outstanding then return all the outstanding scmds with DID_NO_CONNECT
> in the shutdown/unload path itself as shown below,

Apparently there is a problem with that.

That is not enough for TM commands; it's only for SCSI IO commands.

The TM commands use the high-priority queue, and SCSI IO commands use the
SCSI IO queue.  But this patch only waits for and return commands in the
latter:

 > +	mpt3sas_wait_for_commands_to_complete(ioc);
 > +	_scsih_flush_running_cmds(ioc);

They only loop up until 'ioc->scsiio_depth', but TM commands get SMIDs above
that [see mpt3sas_base_free_smid() and mpt3sas_scsih_issue_tm()].

So, there's an exposure for abort/reset/other TM commands. For example, the
SCSI IO commands finish quickly in wait_for_commands_to_complete(), then the
shutdown function continues, disables interrupts, and release
pointers/memory.  Then, an outstanding abort/reset command is finished, its
completion interrupt is not serviced, and the SCSI EH for it kicks
in/continues, and so it escalates up, and hit that oops in host reset.

Is there any problem with the patch that I proposed?

It seems okay to have another check in error path (not hot/performance
path), and that check is already used in many other points in the code, for
the same reasons (exit early before the code attempts to use stuff that
might be released).

Thanks again,

--
Mauricio Faria de Oliveira
IBM Linux Technology Center
