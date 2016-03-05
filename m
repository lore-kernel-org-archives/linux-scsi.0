From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] cxgbit: fix dma_addr_t printk format
Date: Fri, 04 Mar 2016 18:20:25 -0800
Message-ID: <1457144425.4044.147.camel@perches.com>
References: <1457136294-2229829-1-git-send-email-arnd@arndb.de>
	 <1457137507.4044.143.camel@perches.com> <1512908.OAtrKYf46L@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1512908.OAtrKYf46L@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Varun Prakash <varun@chelsio.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 2016-03-05 at 01:34 +0100, Arnd Bergmann wrote:
> On Friday 04 March 2016 16:25:07 Joe Perches wrote:
> > > diff --git a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c b/drivers/t=
arget/iscsi/cxgbit/cxgbit_ddp.c
[]
> > > @@ -179,7 +179,7 @@ cxgbit_dump_sgl(const char *cap, struct scatt=
erlist *sgl, int nents)
> > > =A0=A0=A0=A0=A0=A0for_each_sg(sgl, sg, nents, i)
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pr_info("\t%d/%u, 0x%p:=
 len %u, off %u, pg 0x%p, dma 0x%llx, %u\n",
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
i, nents, sg, sg->length, sg->offset, sg_page(sg),
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s=
g_dma_address(sg), sg_dma_len(sg));
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(=
u64)sg_dma_address(sg), sg_dma_len(sg));
[]
> > You could create a temporary:


=A0=A0=A0=A0=A0=A0=A0=A0for_each_sg(sgl, sg, nents, i) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0dma_addr_t addr =3D sg_=
dma_address(sg);


=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pr_info("\t%d/%u, 0x%p:=
 len %u, off %u, pg 0x%p, dma %pad, %u\n",
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
i, nents, sg, sg->length, sg->offset, sg_page(sg),
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
&addr, sg_dma_len(sg));
=A0=A0=A0=A0=A0=A0=A0=A0}

Sure, but the cast seemed nicer in this case, the result is the same.

Not quite as 0x%llx isn't always the same width and doesn't
have leading 0's like %pad
