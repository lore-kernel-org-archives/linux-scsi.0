From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v10 0/4] ata: Add APM X-Gene SoC SATA host controller
 support
Date: Fri, 14 Feb 2014 10:03:22 -0500
Message-ID: <20140214150322.GB29516@htj.dyndns.org>
References: <CAPw-ZTkbpOEHowGvp-_3DcW1qW0AK_ZbpdS1LESJfhFU-n_Mtw@mail.gmail.com>
 <CAPw-ZTn5c=v+7pbetEjXWpw9i=cG+zdeHPxO1QD0e42uFrKnCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPw-ZTn5c=v+7pbetEjXWpw9i=cG+zdeHPxO1QD0e42uFrKnCg@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, David Milburn <dmilburn@redhat.com>, Jon Masters <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hello, Loc.

On Thu, Feb 13, 2014 at 03:28:01PM -0800, Loc Ho wrote:
> 1. There are a number of errata that require workaround. Some can be
> fixed by adding broken flags while others are better to just wrap
> around the existent libahci library routines and not overly polluting
> the libahci routines.
> 2. There are additional controller programming sequences to configure.
> 2a. By default, RAM are powered down and require brought out of shutdown.
> 2b. The controller has an additional corresponding PHY part that needs
> to be programmed after PHY configuration.

Have you looked at the latest patchset Hans posted?  He added multiple
PHY support and split up init to three steps so that each platform
driver can mix and match as they see fit.  Looking at xgene driver,
sure there are things specific to the driver but there also are
non-insignificant amount of boilerplate code and that's what I'm
primarily concerned about.  It may be okay when you have two or three
drivers duplicating some code but it looks like we could have many
more and I *really* want to avoid the situation where the same piece
of code is copied over N times.  In addition, frankly, not many people
except yourself would care about these drivers once they're merged and
many of these are gonna be painful to test making later refactoring a
lot harder.

> 2c. The controller requires extra programming sequence for the
> hardreset due to errata.
> 2d. For the IO flush, it requires additional memory resources.

Sure, you'll need to override good parts of the driver.  What I'm
saying is please try to reuse whatever you can.  If that takes
refactoring and librarize ahci_platform, please do so and I do see
healthy chunk of duplicated code in the init path.  Please take a look
at Hans' patches and if necessary work with him so that your driver
can be part of the refactoring.

Thanks.

-- 
tejun
