From: Adrian Bunk <bunk@stusta.de>
Subject: 2.6.11-mm4: drivers/scsi/arcmsr/arcmsr.c: enormous stack usage
Date: Sat, 19 Mar 2005 14:39:52 +0100
Message-ID: <20050319133951.GK3143@stusta.de>
References: <20050316040654.62881834.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:63237 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S262576AbVCSNj6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Mar 2005 08:39:58 -0500
Content-Disposition: inline
In-Reply-To: <20050316040654.62881834.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Erich Chen <erich@areca.com.tw>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Mar 16, 2005 at 04:06:54AM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.11-mm3:
>...
> +areca-raid-linux-scsi-driver.patch
> 
>  Updated version of this driver.
>...

<--  snip  -->

...
static int arcmsr_iop_ioctlcmd(PACB pACB, int ioctl_cmd, void *arg)
{
...
uint8_t tmpQbuffer[1032];
...
uint8_t tmpuserbuffer[1032];
...
}
...

<--  snip  -->


1kB allocations from the stack aren't a good idea considering that you 
might have only a 4kB stack altogether.


Running "make checkstack" after compiling the kernel helps you finding 
such problems.


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

