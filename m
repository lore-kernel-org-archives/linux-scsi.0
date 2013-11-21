From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 3/4] ata: Add APM X-Gene SoC SATA host controller driver
Date: Thu, 21 Nov 2013 14:20:28 +0100
Message-ID: <201311211420.28509.arnd@arndb.de>
References: <1384465153-29902-1-git-send-email-lho@apm.com>
 <201311151448.16279.arnd@arndb.de>
 <CAPw-ZTmaz3nnV3ThRgecT_RaYYW0bmfWvL8Kr-S3z1aKyUWc+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAPw-ZTmaz3nnV3ThRgecT_RaYYW0bmfWvL8Kr-S3z1aKyUWc+w@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Loc Ho <lho@apm.com>
Cc: devicetree@vger.kernel.org, Suman Tripathi <stripathi@apm.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jon Masters <jcm@redhat.com>, Kishon Vijay Abraham I <kishon@ti.com>, Tejun Heo <tj@kernel.org>, Olof Johansson <olof@lixom.net>, Tuan Phan <tphan@apm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Saturday 16 November 2013, Loc Ho wrote:


> >
> > config SATA_XGENE
> >         tristate "APM X-Gene 6.0Gbps SATA host controller support"
> >         depends on ARM64 || COMPILE_TEST
> >         ...
> >
> [Loc Ho]
> Okay. How about this?
> 
>  depends on ARM64 || COMPILE_TEST
>  select SATA_XGENE_PHY && SATA_AHCI_PLATFORM

I think you already found the mistake withis and corrected this in v4.

> > The interface you are looking for is pr_debug() or dev_dbg(), which get
> > built-in only if the DEBUG macro is set.
> >
> > In a lot of cases, it's actually best to remove debug output like this from
> > the driver once you have it working  -- whoever is debugging problems in
> > the driver next might need completely different debugging information or
> > can add them back easily if needed.
> >
> > It's your choice if you want to use pr_debug() or remove that output
> > entirely. If you remove it, best remove the helper functions entirely
> > and use readl/writel directly.
> [Loc Ho]
> I would like to keep this function for now until this driver actual
> being used in production. I will use pr_debug.

Ok.

> >> diff --git a/drivers/ata/sata_xgene.h b/drivers/ata/sata_xgene.h
> >> new file mode 100644
> >> index 0000000..51e73f6
> >> --- /dev/null
> >> +++ b/drivers/ata/sata_xgene.h
> >
> > This file should probably just be folded into the driver, since it contains no
> > interfaces between  modules, just internal definitions.
> [Loc Ho]
> I can get rip this header file now. But in the future I may need to
> add this back as I intended this driver to also support running from
> our co-processor (ARMv7 32-bit). For that, I will need anothe file and
> other function that will need knowledge of the context structure and
> etc.

Hmm, is the code for that coprocessor compiled from the kernel source?
If not, it shouldn't really make a difference as it won't live in a shared
code repository.

	Arnd
