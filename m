From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 20/22] scsi: align logging messages
Date: Thu, 18 Sep 2014 23:58:18 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C8BDA3@G9W0745.americas.hpqcorp.net>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
 <1409247216-76074-21-git-send-email-hare@suse.de>
 <20140831222556.GL16432@infradead.org>
 <94D0CD8314A33A4D9D801C0FE68B402958C2F65E@G9W0745.americas.hpqcorp.net>
 <20140906003403.GB18426@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:47280 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbaISAA1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Sep 2014 20:00:27 -0400
In-Reply-To: <20140906003403.GB18426@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
...
> > scmd ties the messages together so you can tell which command
> > has gotten to which state.  grep works.
> 
> Can we just print the tag instead, that would be a much more human
> readable number normally.

I made a local patch to add the tag (scmd->request->tag), and it does
look good.  I endorse dropping scmd %p in favor of just the tag,
and trying to include the tag in all the lines (here, the Done,
Result, CDB, Sense Key, and Add. Sense lines do not)

[  624.607501] sd 2:0:0:3: [sdv] Done: TIMEOUT
[  624.609121] sd 2:0:0:3: [sdv] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
[  624.611542] sd 2:0:0:3: [sdv] CDB: 28 00 43 03 24 98 00 00 08 00
[  624.613637] sd 2:0:0:3: [sdv] scmd ffff880420891470 tag 1 abort scheduled
[  624.616015] sd 2:0:0:3: [sdv] Done: TIMEOUT
[  624.617510] sd 2:0:0:3: [sdv] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
[  624.619792] sd 2:0:0:3: [sdv] CDB: 28 00 52 83 20 80 00 00 08 00
[  624.621855] sd 2:0:0:3: [sdv] scmd ffff880420893a70 tag 3 abort scheduled
[  624.624148] sd 2:0:0:3: [sdv] Done: TIMEOUT
[  624.625739] sd 2:0:0:3: [sdv] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
[  624.628062] sd 2:0:0:3: [sdv] CDB: 28 00 58 a4 64 70 00 00 08 00
[  624.630132] sd 2:0:0:3: [sdv] scmd ffff880420894d70 tag 4 abort scheduled
[  624.632477] sd 2:0:0:3: [sdv] Done: TIMEOUT
[  624.633913] sd 2:0:0:3: [sdv] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
[  624.636291] sd 2:0:0:3: [sdv] CDB: 28 00 16 90 5c 98 00 00 08 00
[  624.638378] sd 2:0:0:3: [sdv] scmd ffff880420899970 tag 8 abort scheduled
...
[  624.780177] sd 2:0:0:3: [sdv] scmd ffff880420976070 tag 161 abort scheduled
[  624.782661] sd 2:0:0:3: [sdv] Done: TIMEOUT
[  624.784092] sd 2:0:0:3: [sdv] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
[  624.786553] sd 2:0:0:3: [sdv] CDB: 28 00 1e dc 59 e0 00 00 08 00
[  624.788617] sd 2:0:0:3: [sdv] scmd ffff880420977370 tag 162 abort scheduled
[  624.790995] sd 2:0:0:3: [sdv] Done: TIMEOUT
[  624.792443] sd 2:0:0:3: [sdv] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
[  624.794835] sd 2:0:0:3: [sdv] CDB: 28 00 1e 83 1f b8 00 00 08 00
[  624.796965] sd 2:0:0:3: [sdv] scmd ffff88042099ac70 tag 191 abort scheduled 

[  624.799433] sd 2:0:0:3: [sdv] aborting scmd ffff880420891470 tag 1
[  624.801601] sd 2:0:0:3: [sdv] scmd ffff880420891470 tag 1 abort failed, rtn FAILED
[  624.804172] sd 2:0:0:3: [sdv] aborting scmd ffff880420893a70 tag 3
[  624.806417] sd 2:0:0:3: [sdv] scmd ffff880420893a70 tag 3 abort failed, rtn FAILED
[  624.808980] sd 2:0:0:3: [sdv] aborting scmd ffff880420894d70 tag 4
[  624.811086] sd 2:0:0:3: [sdv] scmd ffff880420894d70 tag 4 abort failed, rtn FAILED
[  624.813776] sd 2:0:0:3: [sdv] aborting scmd ffff880420899970 tag 8
[  624.815978] sd 2:0:0:3: [sdv] scmd ffff880420899970 tag 8 abort failed, rtn FAILED
[  624.818653] sd 2:0:0:3: [sdv] aborting scmd ffff88042089ac70 tag 9
...
[  624.852244] sd 2:0:0:3: [sdv] scmd ffff880420976070 tag 161 abort failed, rtn FAILED
[  624.855200] sd 2:0:0:3: [sdv] aborting scmd ffff880420977370 tag 162
[  624.857380] sd 2:0:0:3: [sdv] scmd ffff880420977370 tag 162 abort failed, rtn FAILED
[  624.860057] sd 2:0:0:3: [sdv] aborting scmd ffff88042099ac70 tag 191
[  624.862250] sd 2:0:0:3: [sdv] scmd ffff88042099ac70 tag 191 abort failed, rtn FAILED 

[  624.865174] scsi host2: scsi_eh_2: waking up 0/11/11
[  624.866977] sd 2:0:0:3: scsi_eh_prt_fail_stats: cmds failed: 11, cancel: 0
[  624.869276] scsi host2: Total of 11 commands on 1 devices require eh work
[  624.871683] scsi host2: scsi_eh_2: Sending BDR sdev:ffff88042b162800
[  624.974058] hpsa 0000:04:00.0: resetting scsi 2:0:0:3: Direct-Access     HP       LOGICAL VOLUME   RAID-6 SSDSmartPathCap+ En- Exp=3
[  624.978450] sd 2:0:0:3: [sdv] scsi_eh_done scmd ffff880420891470 tag 1 result: 2
[  624.981114] sd 2:0:0:3: [sdv] Done: SUCCESS
[  624.982719] sd 2:0:0:3: [sdv] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
[  624.985083] sd 2:0:0:3: [sdv] CDB: 00 00 00 00 00 00
[  624.986874] sd 2:0:0:3: [sdv] Sense Key : Unit Attention [current]
[  624.988997] sd 2:0:0:3: [sdv] Add. Sense: Bus device reset function occurred ((null)3)

[  624.991727] sd 2:0:0:3: [sdv] scsi_send_eh_cmnd: scmd ffff880420891470 tag 1 timeleft: 9998
[  624.994927] sd 2:0:0:3: [sdv] scsi_send_eh_cmnd: scsi_eh_completed_normally rtn 2001
[  624.997560] sd 2:0:0:3: [sdv] scsi_eh_tur: scmd ffff880420891470 tag 1 rtn 2001
[  625.001243] sd 2:0:0:3: [sdv] scsi_eh_done scmd ffff880420891470 tag 1 result: 0
[  625.003856] sd 2:0:0:3: [sdv] scsi_send_eh_cmnd: scmd ffff880420891470 tag 1 timeleft: 9997
[  625.006864] sd 2:0:0:3: [sdv] scsi_send_eh_cmnd: scsi_eh_completed_normally rtn 2002
[  625.009481] sd 2:0:0:3: [sdv] scsi_eh_tur: scmd ffff880420891470 tag 1 rtn 2002
[  625.011971] sd 2:0:0:3: [sdv] scsi_eh_2: flush retry scmd ffff880420891470 tag 1
[  625.014925] sd 2:0:0:3: [sdv] scsi_eh_2: flush retry scmd ffff880420893a70 tag 3
[  625.017444] sd 2:0:0:3: [sdv] scsi_eh_2: flush retry scmd ffff880420894d70 tag 4
[  625.019984] sd 2:0:0:3: [sdv] scsi_eh_2: flush retry scmd ffff880420899970 tag 8
...
[  625.032918] sd 2:0:0:3: [sdv] scsi_eh_2: flush retry scmd ffff880420976070 tag 161
[  625.035539] sd 2:0:0:3: [sdv] scsi_eh_2: flush retry scmd ffff880420977370 tag 162
[  625.138124] sd 2:0:0:3: [sdv] scsi_eh_2: flush retry scmd ffff88042099ac70 tag 191


---
Rob Elliott    HP Server Storage



