From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] SCSI: fix data corruption caused by ses v2
Date: Fri, 15 Feb 2008 10:44:50 -0800
Message-ID: <200802151044.51586.yinghai.lu@sun.com>
References: <200802090413.53275.yinghai.lu@sun.com>
 <200802131625.17172.yinghai.lu@sun.com>
 <1203090786.3058.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-reply-to: <1203090786.3058.22.camel@localhost.localdomain>
Content-disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, kristen.c.accardi@intel.com, Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-scsi@vger.kernel.org

On Friday 15 February 2008 07:53:06 am James Bottomley wrote:
> On Wed, 2008-02-13 at 16:25 -0800, Yinghai Lu wrote:
> > one system: initrd get courrupted:
> > 
> > RAMDISK: Compressed image found at block 0
> > RAMDISK: incomplete write (-28 != 2048) 134217728
> > crc error
> > VFS: Mounted root (ext2 filesystem).
> > Freeing unused kernel memory: 388k freed
> > init_special_inode: bogus i_mode (177777)
> > Warning: unable to open an initial console.
> > init_special_inode: bogus i_mode (177777)
> > init_special_inode: bogus i_mode (177777)
> > Kernel panic - not syncing: No init found.  Try passing init= option to kernel.
> > 
> > bisected to
> > commit 9927c68864e9c39cc317b4f559309ba29e642168
> > Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Date:   Sun Feb 3 15:48:56 2008 -0600
> > 
> >     [SCSI] ses: add new Enclosure ULD
> > 
> > changes:
> > 1. change char to unsigned char to avoid type change later.
> > 2. preserve len for page1
> > 3. need to move desc_ptr even the entry is not enclosure_component_device/raid.
> >    so keep desc_ptr on right position
> > 4. record page7 len, and double check if desc_ptr out of boundary before touch.
> > 5. fix typo in subenclosure checking: should use hdr_buf instead.
> > 
> > Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
> 
> OK, I added this with a fixup to eliminate the spurious goto
> 

good
