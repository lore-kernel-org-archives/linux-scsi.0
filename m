From: Andrew Patterson <andrew@fc.hp.com>
Subject: Re: Problems with higher SCSI LUN's with SLES8
Date: 04 Sep 2003 17:43:49 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1062719029.10813.198.camel@lvadplx>
References: <A00BBCF927F25E4A9D5F6EE1380CDEF2CC88@hedwig.ysl.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel9.hp.com ([156.153.255.214]:34695 "EHLO atlrel9.hp.com")
	by vger.kernel.org with ESMTP id S261506AbTIDXxY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Sep 2003 19:53:24 -0400
In-Reply-To: <A00BBCF927F25E4A9D5F6EE1380CDEF2CC88@hedwig.ysl.nl>
List-Id: linux-scsi@vger.kernel.org
To: "Zuylen, G. van" <GvZuylen@ysl.nl>
Cc: linux-scsi@vger.kernel.org

On Thu, 2003-09-04 at 01:48, Zuylen, G. van wrote:
> Hi you all,
> 
> We are using a HP DL380 server with a Qlogic 2300 HBA adapter. This adapter
> is connected to a HP EMA12000 SAN (with HSG80 controllers). Behind the HBA
> (qlogic 2300) we see only the devices up to LUN 7, higher LUN are not
> detected. We have tried several things like modifying /etc/modules.conf with
> "options scsi_mod max_scsi_luns=128" and modifying /boot/grub/menu.lst. But
> nothing seems to be working.
> We are using SLES8 with kernel version k_smp-2.4.19-304 and the qlogic
> driver version 6.05.60. Also tested with a newer kernel k_smp-2.4.19-340,
> but this makes no difference. 
> 
> Does anybody know how we can solve this problem or is there somebody who has
> experience with this ?
> 
> Best regards,
> 
> Gert van Zuylen

If you don't mind a little kernel hacking, make sure you have the
following entry in linux/drivers/scsi/scsi_scan.c in the struct dev_info
device_list:

{"DEC","HSG80","*", BLIST_SPARSELUN | BLIST_LARGELUN},  

This entry will find LUN's above 7 even if the array reports itself as
SCSI-2 (which the EMA does) and it allows you to use non-sequential
LUN's, i.e., 1, 2, 3, 6, 13 ...

There might already be the entry:

{"DEC","HSG80","*", BLIST_FORCELUN},

This would work as long as you use sequential LUN's i.e,
1,2,3,4,5,6,7,8,9....

Also make sure you set the controller(s) to SCSI-3 and transparent
failover mode.  SCSI-3 mode will give you a LUN 0 management LUN that
the scsi_scan needs to look above LUN 7. You need transparent failover
mode to eliminate "ghost" LUN's.  You also need to set the LUN
presentation operating system type to "SUN".

Andrew

-- 
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
   Andrew Patterson                          Voice:  (970) 898-3261
   Hewlett-Packard Company                   Email:  andrew@fc.hp.com


