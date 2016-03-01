From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] target/cxgbit: add INET dependency
Date: Tue, 01 Mar 2016 22:21:19 +0100
Message-ID: <2941855.lXKcTvDzjQ@wuerfel>
References: <1456744504-3011977-1-git-send-email-arnd@arndb.de> <1456810108.19657.187.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1456810108.19657.187.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-arm-kernel@lists.infradead.org, Varun Prakash <varun@chelsio.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Monday 29 February 2016 21:28:28 Nicholas A. Bellinger wrote:
> > diff --git a/drivers/target/iscsi/cxgbit/Kconfig b/drivers/target/iscsi/cxgbit/Kconfig
> > index cf335b4dbb4e..ce6f5cca315d 100644
> > --- a/drivers/target/iscsi/cxgbit/Kconfig
> > +++ b/drivers/target/iscsi/cxgbit/Kconfig
> > @@ -1,6 +1,7 @@
> >  config ISCSI_TARGET_CXGB4
> >       tristate "Chelsio iSCSI target offload driver"
> >       depends on ISCSI_TARGET && CHELSIO_T4
> > +     depends on INET
> >       select CHELSIO_T4_UWIRE
> >       ---help---
> >       To compile this driver as module, choose M here: the module
> 
> Odd, ISCSI_TARGET already depends on NET, but I guess that's not enough
> for cxgbit..  ;)
> 

The problem is that you can have CONFIG_NET=y but CONFIG_INET=n

It would probably be reasonable to make the ISCSI_TARGET option depend
on CONFIG_INET directly, which would solve the problem as well.

	Arnd
