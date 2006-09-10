From: mmzz@stat.unipd.it (Alberto Cammozzo)
Subject: Re: lp8000 and 2.6.18-rc6
Date: Sun, 10 Sep 2006 23:04:44 +0200
Message-ID: <20060910210444.GC22873@stat.unipd.it>
References: <20060909210856.GC21263@stat.unipd.it> <20060910135631.GD29775@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [147.162.35.208] ([147.162.35.208]:3984 "EHLO
	stavromula.stat.unipd.it") by vger.kernel.org with ESMTP
	id S964940AbWIJVFH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Sep 2006 17:05:07 -0400
Received: from localhost (argabuthon.stat.unipd.it [147.162.35.209])
	by stavromula.stat.unipd.it (Postfix) with ESMTP id 257B31AF57526
	for <linux-scsi@vger.kernel.org>; Sun, 10 Sep 2006 23:04:53 +0200 (CEST)
Received: from stavromula.stat.unipd.it ([147.162.35.208])
	by localhost (argabuthon.stat.unipd.it [147.162.35.209]) (amavisd-new, port 10024)
	with ESMTP id 28738-08 for <linux-scsi@vger.kernel.org>;
	Sun, 10 Sep 2006 23:04:44 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20060910135631.GD29775@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Sun, Sep 10, 2006 at 07:56:31AM -0600, Matthew Wilcox wrote:
> On Sat, Sep 09, 2006 at 11:08:56PM +0200, Alberto Cammozzo wrote:
> > It's the first time I use this setup... Am I missing something?
> > 
> > lsmod:
> > Module                  Size  Used by
> > lpfc                  145600  0 
> > scsi_transport_fc      25568  1 lpfc
> > iscsi_tcp              19808  1 
> > libiscsi               17504  1 iscsi_tcp
> > scsi_transport_iscsi    23244  3 iscsi_tcp,libiscsi
> > skge                   31312  0 
> > [...]
> 
> does the [...] include sd_mod (or sd?  i forget what it's called)


	Thank you Matthew,

	I suppose you mean sd, scsi disk support. Yes, it is _statically_ 
	included in kernel.
	Another hint: if I "modprobe sg" (scsi generic), a bunch of new sg disks
	show up in dmesg, including those from lpfc.
	I noticed they are recognised as an undefined "scsi" device and not as 
	"sd" (disks) or "st" (tapes) as other devices present in the same system,
	(see channel 7 in attached log).

st 0:0:5:0: Attached scsi generic sg0 type 1
ch 0:0:5:1: Attached scsi generic sg1 type 8
sd 1:0:0:0: Attached scsi generic sg2 type 0
scsi 1:0:15:0: Attached scsi generic sg3 type 3
scsi 1:1:9:0: Attached scsi generic sg4 type 3
scsi 1:2:8:0: Attached scsi generic sg5 type 3
scsi 7:0:1:0: Attached scsi generic sg6 type 0
scsi 7:0:3:0: Attached scsi generic sg7 type 0
sd 8:0:0:0: Attached scsi generic sg8 type 0
scsi 7:0:0:0: Attached scsi generic sg9 type 0
scsi 7:0:2:0: Attached scsi generic sg10 type 0


Anyway here's the full lsmod:
Module                  Size  Used by
sr_mod                 12292  0 
sg                     25340  0 
iscsi_tcp              19808  1 
libiscsi               17504  1 iscsi_tcp
scsi_transport_iscsi    23244  3 iscsi_tcp,libiscsi
lpfc                  145600  0 
scsi_transport_fc      25568  1 lpfc
skge                   31312  0 
via_velocity           28640  0 
crc_ccitt               1888  1 via_velocity
b44                    21484  0 
8139cp                 17856  0 
3c59x                  36776  0 
sctp                  136516  2 [unsafe]
configfs               20784  0 
hwmon                   2372  0 

Kernel scsi conf:
# zgrep SCSI /proc/config.gz  | grep -v ^#
CONFIG_SCSI=y
CONFIG_SCSI_PROC_FS=y
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_ISCSI_TCP=m
CONFIG_SCSI_AIC79XX=y
CONFIG_SCSI_IPS=y
CONFIG_SCSI_LPFC=m

	Alberto

PS: sorry for multiple posts, I had a "spam" reject notice from vger server...

-- 
Alberto Cammozzo
System/Network Manager 
Universita` di Padova -IT 
