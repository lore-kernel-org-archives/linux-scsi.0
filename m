From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH 1/2] codafs: Fix build using bare-metal toolchain
Date: Tue, 28 Aug 2018 20:03:23 +0300
Message-ID: <CAHp75VdiRH_J8QUALDNufdWh0eNnKsTmp5q+RGBassFdMcpEmw@mail.gmail.com>
References: <20180828142421.15335-1-semen.protsenko@linaro.org> <20180828142421.15335-2-semen.protsenko@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180828142421.15335-2-semen.protsenko@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, codalist@coda.cs.cmu.edu, coda@cs.cmu.edu, jaharkes@cs.cmu.edu, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Praneeth Bajjuri <praneeth@ti.com>, paul.sokolovsky@linaro.org, mszeredi@suse.cz, sumit.semwal@linaro.org, Ruslan Bilovol <ruslan.bilovol@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 28, 2018 at 5:24 PM Sam Protsenko
<semen.protsenko@linaro.org> wrote:
>
> The kernel is self-contained project and can be built with bare-metal
> toolchain. But bare-metal toolchain doesn't define u_quad_t type.
> Because of this codafs build fails when building with bare-metal
> toolchain. This patch fixes it by defining u_quad_t type in case when
> non-Linux toolchain is used.

>  #endif /* !KERNEL */

I'm wondering what the heck KERNEL is doing in UAPI header.
Looks like this header is split wrongly in the first place.

> +#if defined(__KERNEL__) && !defined(__linux__) && !defined(_UQUAD_T_) && \

P.S. Actually it's the only header which uses KERNEL in UAPI.
Definitely it should be fixed first.

--
With Best Regards,
Andy Shevchenko
