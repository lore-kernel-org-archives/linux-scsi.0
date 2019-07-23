From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Linux 5.3-rc1
Date: Tue, 23 Jul 2019 08:14:21 -0700
Message-ID: <1563894861.3609.6.camel@HansenPartnership.com>
References: <CAHk-=wiVjkTqzP6OppBuLQZ+t1mpRQC4T+Ho4Wg2sBAapKd--Q@mail.gmail.com>
         <20190722222126.GA27291@roeck-us.net> <20190723054841.GA17148@lst.de>
         <20190723145805.GA5809@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190723145805.GA5809@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Guenter Roeck <linux@roeck-us.net>, Christoph Hellwig <hch@lst.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2019-07-23 at 07:58 -0700, Guenter Roeck wrote:
> On Tue, Jul 23, 2019 at 07:48:41AM +0200, Christoph Hellwig wrote:
> > The fix was sent last morning my time:
> > 
> > https://marc.info/?l=linux-scsi&m=156378725427719&w=2
> 
> Here is the updated bisect for the ppc scsi problem.
> 
> Guenter
> 
> ---
> # bad: [f65420df914a85e33b2c8b1cab310858b2abb7c0] Merge tag 'scsi-
> fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi
> # good: [168c79971b4a7be7011e73bf488b740a8e1135c8] Merge tag 'kbuild-
> v5.3-2' of
> git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild
> git bisect start 'f65420df914a' '168c79971b4a'
> # good: [106d45f350c7cac876844dc685845cba4ffdb70b] scsi: zfcp: fix
> request object use-after-free in send path causing wrong traces
> git bisect good 106d45f350c7cac876844dc685845cba4ffdb70b
> # bad: [bdd17bdef7d8da4d8eee254abb4c92d8a566bdc1] scsi: core: take
> the DMA max mapping size into account
> git bisect bad bdd17bdef7d8da4d8eee254abb4c92d8a566bdc1
> # good: [0cdc58580b37a160fac4b884266b8b7cb096f539] scsi: sd_zbc: Fix
> compilation warning
> git bisect good 0cdc58580b37a160fac4b884266b8b7cb096f539
> # bad: [7ad388d8e4c703980b7018b938cdeec58832d78d] scsi: core: add a
> host / host template field for the virt boundary
> git bisect bad 7ad388d8e4c703980b7018b938cdeec58832d78d
> # good: [f9b0530fa02e0c73f31a49ef743e8f44eb8e32cc] scsi: core: Fix
> race on creating sense cache
> git bisect good f9b0530fa02e0c73f31a49ef743e8f44eb8e32cc
> # first bad commit: [7ad388d8e4c703980b7018b938cdeec58832d78d] scsi:
> core: add a host / host template field for the virt boundary

And reverting that commit fixes your problem?

James
