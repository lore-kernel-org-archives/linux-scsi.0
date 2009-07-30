From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux-next: scsi-rc-fixes tree build failure
Date: Thu, 30 Jul 2009 08:51:22 -0500
Message-ID: <1248961882.3880.4.camel@mulgrave.site>
References: <20090730181345.cec774b2.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20090730181345.cec774b2.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Tom Peng <tom_peng@usish.com>, Jack Wang <jack_wang@usish.com>, Lindar Liu <lindar_liu@usish.com>, Kevin Ao <aoqingyun@usish.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2009-07-30 at 18:13 +1000, Stephen Rothwell wrote:
> Hi James,
> 
> Today's linux-next build (powerpc allyesconfig) failed like this:
> 
> drivers/scsi/libsas/sas_expander.c: In function 'sas_find_bcast_dev':
> drivers/scsi/libsas/sas_expander.c:1701: error: 'FALSE' undeclared (first use in this function)
> drivers/scsi/libsas/sas_expander.c: In function 'sas_discover_new':
> drivers/scsi/libsas/sas_expander.c:1809: error: 'FALSE' undeclared (first use in this function)
> drivers/scsi/libsas/sas_expander.c:1824: error: 'TRUE' undeclared (first use in this function)
> drivers/scsi/libsas/sas_expander.c: In function 'sas_rediscover':
> drivers/scsi/libsas/sas_expander.c:1903: error: 'TRUE' undeclared (first use in this function)
> drivers/scsi/libsas/sas_expander.c:1918: error: 'FALSE' undeclared (first use in this function)
> drivers/scsi/libsas/sas_expander.c: In function 'sas_ex_revalidate_domain':
> drivers/scsi/libsas/sas_expander.c:1951: error: 'TRUE' undeclared (first use in this function)
> 
> Caused by commit 4c70d933a41e1d712f3db90d2a41141730383d5a ("[SCSI]
> libsas: fix wide port hotplug issues").  Presumably a missing include
> file.

Actually, I don't think so.  It's confusion over the use of boolean
variables.  I think they have to be set to lower case true, false, not
upper case.  There's obviously some accidental definition of TRUE and
FALSE in x86.

> I have reverted that commit for today.

Thanks, I've dropped it from my tree ... I'll put it back when this is
sorted out.

James
