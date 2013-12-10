From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Do anybody know the format of bsg device node name?
Date: Tue, 10 Dec 2013 11:04:49 +0100
Message-ID: <52A6E741.8060609@interlog.com>
References: <20131209194650.27687.56358.stgit@viggo.jf.intel.com> <20131210103247.9151.46AD7750@newtech.co.jp>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:36811 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab3LJKEz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Dec 2013 05:04:55 -0500
In-Reply-To: <20131210103247.9151.46AD7750@newtech.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Newtech Tan <tan@newtech.co.jp>, linux-scsi@vger.kernel.org

On 13-12-10 02:32 AM, Newtech Tan wrote:
>
> For example of bsg device node name:
> [4:0:0:0]
>
> Each field is Hex or Dec?
>
> [BackGroup]
> I am using lsscsi -g command to get SCSI device list as the following.
> If bsg device name's target number field is over ten, Will it display [4:0:10:0] or [4:0:a:0]?
>
> # lsscsi -g
> [0:0:0:0]    cd/dvd  HL-DT-ST DVD+-RW GSA-H53N B104  /dev/sr0   /dev/sg0
> [3:0:0:0]    disk    ATA      WDC WD1600AAJS-1 05.0  /dev/sda   /dev/sg1
> [4:0:0:0]    disk    ATA      Hitachi HDT72102 A31B  /dev/sdb   /dev/sg2
> [4:0:1:0]    disk    ATA      Hitachi HDT72502 A73A  /dev/sdc   /dev/sg3
> [4:0:2:0]    disk    ATA      Hitachi HDT72502 A73A  /dev/sdd   /dev/sg4
> [4:0:3:0]    disk    ATA      Hitachi HDT72502 A73A  /dev/sde   /dev/sg5
> [4:0:4:0]    disk    ATA      Hitachi HDT72502 A73A  /dev/sdf   /dev/sg6
> [4:0:5:0]    disk    ATA      Hitachi HDT72502 A73A  /dev/sdg   /dev/sg7
> [4:0:6:0]    disk    ATA      Hitachi HDT72502 A73A  /dev/sdh   /dev/sg8
> [4:0:7:0]    disk    ATA      Hitachi HDT72502 A73A  /dev/sdi   /dev/sg9
> [4:0:8:0]    enclosu LSI      SAS616x          0502  -         /dev/sg10

/dev/bsg/0:0:0:0
/dev/bsg/3:0:0:0
/dev/bsg/4:0:0:0
etc

Depending on your shell you may need to escape the ":"
characters (or surround the whole string in quotes).

Also CONFIG_BLK_DEV_BSG needs to be defined in your kernel
build but as udev needs that, that is probably already the
case.

Looks like you have a SAS expander there as well. It will
have a bsg node name like:
   /dev/bsg/expander-4:0
that my smp_utils package can use. There might also be a
SAS host node like this:
   /dev/bsg/sas_host4


Doug Gilbert


