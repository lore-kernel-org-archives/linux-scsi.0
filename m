From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH] mptsas: scan the logical volume at first
Date: Mon, 27 Aug 2007 16:20:16 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D709409BA@NAMAIL4.ad.lsil.com>
References: <200708271058.01919.yinghai.lu@sun.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762017AbXH0WUu@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <200708271058.01919.yinghai.lu@sun.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yinghai Lu <Yinghai.Lu@Sun.COM>, Andrew Morton <akpm@linux-foundation.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, James Bottomley <James.Bottomley@steeleye.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mpt_linux_developer@lsi.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Monday, August 27, 2007 11:58 AM,  Yinghai Lu wrote:
> 
> [PATCH] mptsas: scan the logical volume at first
> 
> user like to see the raid show as /dev/sda before left raw disks.
> So scan the volume at first to make their life easier.
> 
> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
> 

Although I agree with the patch, there are people on this list that will
reject it due to the fact distro's ship today having udev label and
device id mapping, so device ordering should be an non-issue.  However
there are systems that ship that don't have BIOS BBS support, allowing
you to select the boot device. Without it BBS support, you are forced to
boot to the lowest device id.  There are HP and Dell systems like that.
Are SUN systems like that?   If so, there is an additional patch which I
have yet posted that will sort the raid volumes in acsending order.
Currently they are in descending order (due to Firmware putting them in
that order), which if you did a install to what you think is /dev/sda,
its really the highest target id, and when you reboot, the BIOS will
boot to the lowest id, which is /dev/sdb, and it will not find the boot
partition.

Eric
