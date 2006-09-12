From: mmzz@stat.unipd.it (Alberto Cammozzo)
Subject: Re: lp8000 and 2.6.18-rc6
Date: Tue, 12 Sep 2006 08:45:14 +0200
Message-ID: <20060912064514.GA28121@stat.unipd.it>
References: <20060909210856.GC21263@stat.unipd.it> <20060910135631.GD29775@parisc-linux.org> <20060910210444.GC22873@stat.unipd.it> <4504B6AF.3080909@torque.net> <20060911064008.GA26293@stat.unipd.it> <1157994026.3470.3.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stavromula.stat.unipd.it ([147.162.35.208]:24253 "EHLO
	stavromula.stat.unipd.it") by vger.kernel.org with ESMTP
	id S1750801AbWILGp0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Sep 2006 02:45:26 -0400
Received: from localhost (argabuthon.stat.unipd.it [147.162.35.209])
	by stavromula.stat.unipd.it (Postfix) with ESMTP id 040231AF574E2
	for <linux-scsi@vger.kernel.org>; Tue, 12 Sep 2006 08:45:23 +0200 (CEST)
Received: from stavromula.stat.unipd.it ([147.162.35.208])
	by localhost (argabuthon.stat.unipd.it [147.162.35.209]) (amavisd-new, port 10024)
	with ESMTP id 01959-01 for <linux-scsi@vger.kernel.org>;
	Tue, 12 Sep 2006 08:45:14 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1157994026.3470.3.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Mon, Sep 11, 2006 at 12:00:26PM -0500, James Bottomley wrote:
> On Mon, 2006-09-11 at 08:40 +0200, Alberto Cammozzo wrote:
> > standard INQUIRY:
> >   PQual=1  Device_type=0  RMB=0  [ANSI_version=4]  version=0x04
> 
> That's the reason:  Peripheral Qualifier Not Connected.  sd won't bind
> to this device.
> 
> So, the next thing that would be tried is a report lun scan which seems
> to have failed for some reason.
> 
> What does
> 
> sg_luns -v /dev/sg6
> 
> give?

	Here it is:

novantatre:~# dmesg
[...]
st 0:0:5:0: Attached scsi generic sg0 type 1
ch 0:0:5:1: Attached scsi generic sg1 type 8
sd 1:0:0:0: Attached scsi generic sg2 type 0
scsi 1:0:15:0: Attached scsi generic sg3 type 3
scsi 1:1:9:0: Attached scsi generic sg4 type 3
scsi 1:2:8:0: Attached scsi generic sg5 type 3
scsi 2:0:0:0: Attached scsi generic sg6 type 0
scsi 2:0:1:0: Attached scsi generic sg7 type 0
scsi 2:0:2:0: Attached scsi generic sg8 type 0
scsi 2:0:3:0: Attached scsi generic sg9 type 0
sd 3:0:0:0: Attached scsi generic sg10 type 0

novantatre:~# sg_luns -v sg6
sg_luns: open error: sg6: No such file or directory
novantatre:~# sg_luns -v /dev/sg6
    report luns cdb: a0 00 00 00 00 00 00 00 04 00 00 00 
    report luns: requested 1024 bytes but got 32 bytes
Lun list length = 24 which imples 3 lun entries

Output response in hex
 00     00 00 00 18 00 00 00 00  00 01 00 00 00 00 00 00                    
 10     00 03 00 00 00 00 00 00  00 04 00 00 00 00 00 00                    
Report luns [select_report=0]:
    0001000000000000
    0003000000000000
    0004000000000000





	Alberto
