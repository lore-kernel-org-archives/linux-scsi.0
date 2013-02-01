From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: How to online remove an error scsi disk from the system?
Date: Fri, 1 Feb 2013 16:50:19 +0800
Message-ID: <008101ce0059$2a4976b0$7edc6410$@com>
References: <510B5CFC.2040801@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:60746 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab3BAJBr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Feb 2013 04:01:47 -0500
In-Reply-To: <510B5CFC.2040801@tao.ma>
Content-Language: zh-cn
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Tao Ma' <tm@tao.ma>, linux-scsi@vger.kernel.org, 'LKML' <linux-kernel@vger.kernel.org>

Hi All,
	In our product system, we have several sata disks attached to one
machine. So when one of the disk fails, the jbd2(yes, we use ext4) will hang
forever and we will get something in /var/log/messages like below.
It seems to me that the io sent to the scsi layer is never returned back
with -EIO which is a little bit surprised for me(It should be a timeout
somewhere, right?). We have tried echo "offline" >
/sys/block/sdl/device/state, but it doesn't work. So is there any way for us
to let the scsi device returns all the io requests back with EIO so that all
the end_io can be called accordingly? Am I missing something here?

Thanks,
Tao
[Jack Wang] 
Hi Tao,

Have you tried:
 echo 1 > /sys/block/sdv/device/delete
 echo "- - -" > /sys/class/scsi_host/host

another way is :
find out which phy the disk attached to and:
echo 1 > /sys/class/sas_phy/phy-x:x:x/link_reset

Jack

