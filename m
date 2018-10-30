From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [v6 1/4] mpt3sas: Separate out
 mpt3sas_wait_for_ioc_to_operational
Date: Tue, 30 Oct 2018 08:22:32 -0500
Message-ID: <20181030132232.GA41022@google.com>
References: <1540290081-15827-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1540290081-15827-2-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1540290081-15827-2-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Cc: lukas@wunner.de, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, benh@kernel.crashing.org, ruscur@russell.cc, sbobroff@linux.ibm.com, oohall@gmail.com, andy.shevchenko@gmail.com, Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 23, 2018 at 03:51:18PM +0530, Suganath Prabu wrote:
> No functional changes. This section of code
>  "wait for IOC to be operational" is used in many places
>  across the driver, and hence moved this code in to
>  a function "mpt3sas_wait_for_ioc_to_operational()"
> 
> Signed-off-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>

I'm not really a reviewer of mpt3sas, but since I commented earlier,
I took a quick look at this.  Minor comments:

  - Remove leading spaces from changelog and reformat to use the whole
    width, e.g.,

      No functional changes. This section of code "wait for IOC to be
      operational" is used in many places across the driver.  Factor
      this code out into a new mpt3sas_wait_for_ioc_to_operational().

  - "mpt3sas_wait_for_ioc_to_operational" isn't really grammatical in
    English; maybe "mpt3sas_wait_for_ioc" would be better?

  - It would be slightly easier to review this if it were split into three
    patches: (1) add and use the IOC_OPERATIONAL_WAIT_COUNT #define, (2)
    factor out mpt3sas_wait_for_ioc() using the exact same code structure
    (the while loop), and (3) convert mpt3sas_wait_for_ioc() to use the do
    loop instead of the while.  The idea is that each individual patch is
    simpler and more obvious because it only contains a single logical
    change.

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
