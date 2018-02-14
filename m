From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] scsi: mpt3sas: fix oops in error handlers after
 shutdown/unload
Date: Wed, 14 Feb 2018 13:35:07 -0200
Message-ID: <c2d58b10-b927-4a06-5edf-69f9fdb05bbd@linux.vnet.ibm.com>
References: <1517523386-9868-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <2fd5c995219c5e07ef04765f67b9b8a7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44580 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1031287AbeBNPfS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Feb 2018 10:35:18 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w1EFY4pD073799
        for <linux-scsi@vger.kernel.org>; Wed, 14 Feb 2018 10:35:18 -0500
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2g4ptjua0q-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 14 Feb 2018 10:35:17 -0500
Received: from localhost
        by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Wed, 14 Feb 2018 08:35:16 -0700
In-Reply-To: <2fd5c995219c5e07ef04765f67b9b8a7@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>, linux-scsi@vger.kernel.org, Bart.VanAssche@wdc.com
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, dougmill@linux.vnet.ibm.com

Hi Sreenkanth,

Thanks for reviewing.

On 02/12/2018 04:28 AM, Sreekanth Reddy wrote:
> Instead of returning the scmd with DID_NO_CONNECT in TM path, can we wait
> for some time (10 seconds) in shutdown/unload path for the outstanding
> commands to complete and even then [if] the scmds are outstanding then return
> all the outstanding scmds with DID_NO_CONNECT in the shutdown/unload path
> itself as shown below,

Apparently there is a problem with that.

That is not enough for TM commands; it's only for SCSI IO commands.

The TM commands use the high-priority queue, and SCSI IO commands use
the SCSI IO queue.  But this patch only waits for and return commands
in the latter:

 > +	mpt3sas_wait_for_commands_to_complete(ioc);
 > +	_scsih_flush_running_cmds(ioc);

They only loop up until 'ioc->scsiio_depth', but TM commands get SMIDs
above that [see mpt3sas_base_free_smid() and mpt3sas_scsih_issue_tm()].

So, there's an exposure for abort/reset/other TM commands. For example,
the SCSI IO commands finish quickly in wait_for_commands_to_complete(),
then the shutdown function continues, disables interrupts, and release
pointers/memory.  Then, an outstanding abort/reset command is finished,
its completion interrupt is not serviced, and the SCSI EH for it kicks
in/continues, and so it escalates up, and hit that oops in host reset.

Is there any problem with the patch that I proposed?

It seems okay to have another check in error path (not hot/performance
path), and that check is already used in many other points in the code,
for the same reasons (exit early before the code attempts to use stuff
that might be released).

Thanks again,

-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
