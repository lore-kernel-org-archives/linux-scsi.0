From: Aniket Kulkarni <aniket@linux.vnet.ibm.com>
Subject: Question about releasing buffers allocated to request->special
Date: Wed, 25 Jul 2012 11:52:59 -0400
Message-ID: <20120725115259.Horde.CgVQ7Jir309QEBZbCdfg4HA@imap.linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:47854 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab2GYPyR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jul 2012 11:54:17 -0400
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <aniket@linux.vnet.ibm.com>;
	Wed, 25 Jul 2012 09:54:15 -0600
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 124A61FF0098
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jul 2012 15:53:08 +0000 (WET)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q6PFr0Pt066950
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jul 2012 09:53:00 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q6PFqxv4012665
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jul 2012 09:52:59 -0600
Received: from imap.linux.ibm.com (maier.raleigh.ibm.com [9.37.253.158])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id q6PFqxNL012641
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jul 2012 09:52:59 -0600
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello

I have a setup with a 12 daisy chained EXP3000 enclosures connected to
a server such that each of the disks are accessible via two paths
through multiple sas expanders. The server has 2 dual ported HBAs. I'm
running 2.6.32 kernel variant based on RHEL 6.0. I have seen this on
2.6.31 as well.

I am seeing a bunch of kernel panics pretty frequently with an
interesting pattern -

The kernel paniced trying to deference stuff from scsi_cmnd passed to  
scsi_dispatch_cmd. Looking at its caller

scsi_request_fn(request_queue *q)
     device = q->quedata;
     req = get_request_from_queue(q);

     cmd = req->special;
     if (!cmd)
         return;

     scsi_dispatch_cmd(cmd);

The interesting thing is cmd->device != device; they should've been  
the same. In fact it looks like req->special itself is garbage and  
that's why we have been looking at the wrong stuff in  
scsi_dispatch_cmd. It also explains why we can find the device on  
upper frames and prove that it (and all its attributes) are healthy  
all the way from MD to LSI.

The only place in scsi layer that frees req->special is

scsi_prep_return()
....
     case BLKPREP_KILL:
         req->errors = DID_NO_CONNECT << 16;
         /* release the command and kill it */
         if (req->special) {
             struct scsi_cmnd *cmd = req->special;   <--
             scsi_release_buffers(cmd);                |__ not atomic
             scsi_put_command(cmd);                    |
             req->special = NULL;                    <--
         }

I know this is a basic question, but I'm wondering how does one  
prevent threads from using req->special while its being deallocated  
here? I see checks for special == NULL at a lot of places but the  
release and reset of pointer (above) are not atomic.

Thanks in advance.
-- 
Aniket Kulkarni


