From: Patrick Mansfield <patmans@us.ibm.com>
Subject: INQUIRY VPD page 0 hangs disk [was scsi_error device offline fix]
Date: Tue, 22 Oct 2002 12:05:03 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20021022120503.A4185@eng2.beaverton.ibm.com>
References: <20021022083815.A61@eng2.beaverton.ibm.com> <Pine.LNX.4.30.0210220905560.20878-100000@tosko.alm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.30.0210220905560.20878-100000@tosko.alm.com>; from andyb@island.net on Tue, Oct 22, 2002 at 09:14:55AM -0700
To: andy barlak <andyb@island.net>
Cc: Mike Anderson <andmike@us.ibm.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 22, 2002 at 09:14:55AM -0700, andy barlak wrote:
> 
> On Tue, 22 Oct 2002, Patrick Mansfield wrote:
> > Try removing the scsi_load_identifier call in scsi_scan.c and
> > see if you can boot. And/or get sg_utils and on your 2.4 system
> > send a INQUIRY page 0 to the device, and see if that hangs or
> > not, like:
> 
> 
> On this 2.4.19 box with the Buslogic 958, that command hangs:
> # ./sg_inq -e -o=0 /dev/sg1
> EVPD INQUIRY, page code=0x00:
> 

That really sucks.

If you remove the scsi_load_identifier, does 2.5 boot?

We can black list your device, never sending it INQUIRY page 0.

Since there is one disk like yours out there, there are probably more,
so we should add a module/boot and maybe config time option to disable
the INQUIRY page 0.

Anyone have some other suggestion, besides throwing away the disk?

-- Patrick Mansfield
