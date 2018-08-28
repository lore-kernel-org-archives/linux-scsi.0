From: adam radford <aradford@gmail.com>
Subject: Re: Bug in /drivers/scsi/3w-9xxx.h
Date: Tue, 28 Aug 2018 10:33:03 -0700
Message-ID: <CAHtARFHovpNRx-hdZCAYD9zjUf0WWdRvQ8PkqPNjNpbUwPRqow@mail.gmail.com>
References: <491de4ae-0ba3-0fce-a400-3ebb41e21ac4@mni.thm.de> <e79d43eb-38cb-8975-08c9-c3937a1276c2@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e79d43eb-38cb-8975-08c9-c3937a1276c2@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: rdunlap@infradead.org
Cc: frank.kammer@mni.thm.de, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Frank,

host->max_id (max scsi target ID's) is set to TW_MAX_UNITS_9650SE for
your adapter, which is 32.

The firmware srl (spec revision level) for your 9650 adapter doesn't
support luns > (0 .. 16).

You could run in this mode but it hasn't been tested, and I don't
recall what the ramifications may be (if any).

-Adam



On Tue, Aug 28, 2018 at 10:02 AM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> [add linux-scsi list]
>
> On 08/28/2018 05:23 AM, Frank Kammer wrote:
> > Hello,
> >
> > I have a 3ware 9650SE RAID-Controller with 20 LUNs. Using an unpachted
> > kernel (no matter which version, e.g., 4.12.14) , only 17 LUNs are shown.
> >
> > The problem is that the driver was once written for a 3ware 9550SE
> > RAID-Controlle that supports only 16 LUNs.
> > There are some changes in driver to allow 32 LUNs, but one change is
> > forgotten:
> >
> > In drivers/scsi/3w-9xxx.h, one must replace the following:
> >
> > 467c467
> > < #define TW_MAX_LUNS(srl) (srl < TW_FW_SRL_LUNS_SUPPORTED ? 1 : 16)
> > ---
> >> #define TW_MAX_LUNS(srl) (srl < TW_FW_SRL_LUNS_SUPPORTED ? 1 : 32)
> >
> > Best regards,
> > Frank Kammer
> >
>
>
> --
> ~Randy
