From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v2 6/8] tools rpmb: add RPBM access tool
Date: Mon, 11 Apr 2016 08:33:14 -0500
Message-ID: <20160411133314.gzjuqzadhoxf3u3i@treble>
References: <1459768284-26997-1-git-send-email-tomas.winkler@intel.com>
 <1459768284-26997-7-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1459768284-26997-7-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: gregkh@linuxfoundation.org, Ulf Hansson <ulf.hansson@linaro.org>, Adrian Hunter <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, Joao Pinto <Joao.Pinto@synopsys.com>, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Tomas,

On Mon, Apr 04, 2016 at 02:11:22PM +0300, Tomas Winkler wrote:
> Add simple RPMB host testing tool. It can be used
> to program key, write and read data block, and retrieve
> write counter.
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
> V2: resend
>  MAINTAINERS           |   1 +
>  tools/Makefile        |  16 +-
>  tools/rpmb/.gitignore |   2 +
>  tools/rpmb/Makefile   |  32 ++
>  tools/rpmb/rpmb.c     | 807 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 853 insertions(+), 5 deletions(-)
>  create mode 100644 tools/rpmb/.gitignore
>  create mode 100644 tools/rpmb/Makefile
>  create mode 100644 tools/rpmb/rpmb.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 07bd6f380460..b7966b95c265 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9425,6 +9425,7 @@ F:	drivers/char/rpmb/*
>  F:	include/uapi/linux/rpmb.h
>  F:	include/linux/rpmb.h
>  F:	Documentation/ABI/testing/sysfs-class-rpmb
> +F:	tools/rpmb/
>  
>  RTL2830 MEDIA DRIVER
>  M:	Antti Palosaari <crope@iki.fi>
> diff --git a/tools/Makefile b/tools/Makefile
> index 60c7e6c8ff17..5b37ccd95cab 100644
> --- a/tools/Makefile
> +++ b/tools/Makefile
> @@ -19,6 +19,7 @@ help:
>  	@echo '  lguest                 - a minimal 32-bit x86 hypervisor'
>  	@echo '  net                    - misc networking tools'
>  	@echo '  perf                   - Linux performance measurement and analysis tool'
> +	@echo '  rpmb                   - Replay protected memory block access tool'
>  	@echo '  selftests              - various kernel selftests'
>  	@echo '  spi                    - spi tools'
>  	@echo '  objtool                - an ELF object analysis tool'
> @@ -55,7 +56,8 @@ acpi: FORCE
>  cpupower: FORCE
>  	$(call descend,power/$@)
>  
> -cgroup firewire hv guest spi usb virtio vm net iio gpio objtool: FORCE
> +cgroup firewire hv guest rpmb spi usb virtio vm net iio gpio objtool: FORCE
> +cgroup firewire hv guest rpmb spi usb virtio vm net iio: FORCE

This looks like an artifact from a bad merge resolution.  The second
line needs to be deleted.  This probably explains the kbuild robot build
errors, since CONFIG_STACK_VALIDATION requires objtool to be built.

>  	$(call descend,$@)
>  
>  liblockdep: FORCE
> @@ -85,7 +87,7 @@ freefall: FORCE
>  	$(call descend,laptop/$@)
>  
>  all: acpi cgroup cpupower hv firewire lguest \
> -		perf selftests turbostat usb \
> +		perf rpmb selftests turbostat usb \
>  		virtio vm net x86_energy_perf_policy \
>  		tmon freefall objtool
>  
> @@ -95,7 +97,8 @@ acpi_install:
>  cpupower_install:
>  	$(call descend,power/$(@:_install=),install)
>  
> -cgroup_install firewire_install hv_install lguest_install perf_install usb_install virtio_install vm_install net_install objtool_install:
> +cgroup_install firewire_install hv_install lguest_install perf_install rpmb_install usb_install virtio_install vm_install net_install objtool_install:
> +cgroup_install firewire_install hv_install lguest_install perf_install rpmb_install usb_install virtio_install vm_install net_install:

Same here.


-- 
Josh
