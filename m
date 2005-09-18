From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/5] convert st to use scsi_execte_async
Date: Sun, 18 Sep 2005 11:08:54 -0500
Message-ID: <432D9116.6040405@cs.wisc.edu>
References: <1126845599.9276.44.camel@max>  <Pine.LNX.4.61.0509171428410.9258@kai.makisara.local>  <432C39BC.1030105@cs.wisc.edu>  <432C3C75.5090405@cs.wisc.edu> <1126974325.10413.5.camel@max> <Pine.LNX.4.61.0509181456370.14776@kai.makisara.local> <432D81BD.9080803@cs.wisc.edu> <432D8515.9010809@cs.wisc.edu> <Pine.LNX.4.61.0509182031090.15507@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:33490 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932147AbVIRSJA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Sep 2005 14:09:00 -0400
In-Reply-To: <Pine.LNX.4.61.0509182031090.15507@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

Kai Makisara wrote:
> The command triggering these problems is a 6-byte read of 10240 bytes. It 
> should not a this point return anything but finish with some sense data.
> 
> I am debugging the problem but it is going slowly because the system disk 
> is a SCSI disk. I have to be careful with the debugging output and changes 
> outside st.c require a reboot ;-) So far I have found out that 
> scsi_check_sense() is called correctly and returns SUCCESS as it should. 
> What happens after that is a mystery.
> 

If we sent the command as multiple segments then since scsi_generic_done 
just does this

scsi_io_completion(cmd, cmd->result == 0 ? cmd->bufflen : 0, 0);

we could up gettting here in scsi_io_completion() (or depding on the 
sense we could get retired further up in that function).


/*
  * Mark a single buffer as not uptodate.  Queue the remainder.
  * We sometimes get this cruft in the event that a medium error
  * isn't properly reported.
  */
block_bytes = req->hard_cur_sectors << 9;
if (!block_bytes)
	block_bytes = req->data_len;
scsi_end_request(cmd, 0, block_bytes, 1);


and if this command has multiple segments we only partially complete the 
command and the rest gets retried.
