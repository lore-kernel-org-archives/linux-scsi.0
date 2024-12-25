Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BCB412EBE9;
	Wed, 25 Dec 2024 21:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735162363; cv=none; b=IGy181iwaAUaK9z+tmx6cPvwaHbE3bPF62AOmOE1g074V0HuANbTfF2AI43tHhGTmVMbJfhIxVP3j7U5Latxo+BwaQr2cOCLhV059luHoQiSB5Rae6B+8hLePKT0iEYIr/9F6lypO2MALsLKtNDTUHlj4PvV+KazbXqA3rkvOzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735162363; c=relaxed/simple;
	bh=p6wU63mP0Ce8N4rkONd2c4KFHImfEcoVdP8CoL2gHvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kiDVg79CSLeX/B+ZUe/0eq0YeMFx5S8alBn3CcjapTxVNyJUZN16ZF1KbbyGGtTpUhbMUUzUJxIu4D/wFsc64bwDi5CBLk2IiJnd063Bhzi8CEjWlA8A6paKPUMi5H+rabGuR648PzcrZismPVwalWsZcCMik7NDTCHiNVz+xtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pbog0esV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pbog0esV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0EBC4CECD;
	Wed, 25 Dec 2024 21:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735162363;
	bh=p6wU63mP0Ce8N4rkONd2c4KFHImfEcoVdP8CoL2gHvw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pbog0esVgG4MLIIsuz+DLOg7BFsftY6T1NVyoVXQ4zt8MFdgWpBqHD0HW7GApuIwu
	 V2j0RMFqlLafz3MrO9hjILQ5ZSsNLWGdfNoq5LEZQQLNuM6XInoZfwqwtI/moTt6HU
	 YkOwI+6upGsbQU7N6Ejea/y9SvmRwqAp3tWeIUqcPVW0B09dLWF0qMAiTIiDd3TOsN
	 2y42BhR9eUNnsY5mK5iBp5aXQwIxysnUkPXSky4AQORmMMXGF4oHveYZ9t/sKsXQmM
	 qQLPm347F/BX1T0CiZQhZ06kECKngjCdEZekdfdO8kbdM23OeExE+VNOHKHgNBmoV4
	 Hmzyn2Swd2jzA==
Date: Wed, 25 Dec 2024 13:32:41 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, Ard Biesheuvel <ardb@kernel.org>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [linux-next:master] [x86/crc32]  55d1ecceb8:
 INFO:task_blocked_for_more_than#seconds
Message-ID: <20241225213241.GA1939@sol.localdomain>
References: <202412251418.8e78094d-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202412251418.8e78094d-lkp@intel.com>

On Wed, Dec 25, 2024 at 02:50:22PM +0800, kernel test robot wrote:
> 
> Hello,
> 
> 
> we don't have enough knowledge how to connect the changes in 55d1ecceb8 with
> the random issue we found. we tried rebuild kernel and rerun more till to 200
> times for both 55d1ecceb8 and its parent, still observed the issue on 55d1ecceb8
> but clean on parent.
> 
> 1e6b72e60a5a16dd 55d1ecceb8d6a5c9ceff7c65280
> ---------------- ---------------------------
>        fail:runs  %reproduction    fail:runs
>            |             |             |
>            :200         29%          58:200   dmesg.INFO:task_blocked_for_more_than#seconds
> 
> the config diff is:
> 
> --- /pkg/linux/i386-randconfig-011-20241220/gcc-12/1e6b72e60a5a16ddda9c0669da7538f497838d0a/.config     2024-12-24 17:07:56.621157765 +0800
> +++ /pkg/linux/i386-randconfig-011-20241220/gcc-12/55d1ecceb8d6a5c9ceff7c6528075bd0ce4e8366/.config     2024-12-24 15:40:46.814065639 +0800
> @@ -5700,8 +5700,6 @@ CONFIG_CRYPTO_HASH_INFO=y
>  CONFIG_CRYPTO_AES_NI_INTEL=y
>  CONFIG_CRYPTO_SERPENT_SSE2_586=y
>  CONFIG_CRYPTO_TWOFISH_586=y
> -CONFIG_CRYPTO_CRC32C_INTEL=y
> -# CONFIG_CRYPTO_CRC32_PCLMUL is not set
>  # end of Accelerated Cryptographic Algorithms for CPU (x86)
> 
>  CONFIG_CRYPTO_HW=y
> @@ -5798,7 +5796,10 @@ CONFIG_CRC_T10DIF=y
>  CONFIG_CRC64_ROCKSOFT=y
>  CONFIG_CRC_ITU_T=y
>  CONFIG_CRC32=y
> +CONFIG_ARCH_HAS_CRC32=y
>  # CONFIG_CRC32_SELFTEST is not set
> +# CONFIG_CRC32_IMPL_ARCH_PLUS_SLICEBY8 is not set
> +# CONFIG_CRC32_IMPL_ARCH_PLUS_SLICEBY1 is not set
>  # CONFIG_CRC32_IMPL_SLICEBY8 is not set
>  CONFIG_CRC32_IMPL_SLICEBY4=y
>  # CONFIG_CRC32_IMPL_SLICEBY1 is not set
> 
> 
> so we still make out below report FYI.
> 
> 
> kernel test robot noticed "INFO:task_blocked_for_more_than#seconds" on:
> 
> commit: 55d1ecceb8d6a5c9ceff7c6528075bd0ce4e8366 ("x86/crc32: expose CRC32 functions through lib")
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> 
> [test failed on linux-next/master 8155b4ef3466f0e289e8fcc9e6e62f3f4dceeac2]
> 
> in testcase: trinity
> version: 
> with following parameters:
> 
> 	runtime: 300s
> 	group: group-00
> 	nr_groups: 5
> 
> 
> 
> config: i386-randconfig-011-20241220
> compiler: gcc-12
> test machine: qemu-system-i386 -enable-kvm -cpu SandyBridge -smp 2 -m 4G
> 
> (please refer to attached dmesg/kmsg for entire log/backtrace)
> 
> 
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202412251418.8e78094d-lkp@intel.com
> 
> 
> [  996.907142][   T25] INFO: task swapper:1 blocked for more than 491 seconds.
> [  996.911246][   T25]       Not tainted 6.13.0-rc1-00013-g55d1ecceb8d6 #1
> [  996.940897][   T25] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  996.960487][   T25] task:swapper         state:D stack:0     pid:1     tgid:1     ppid:0      flags:0x00004000
> [  997.029537][   T25] Call Trace:
> [ 997.046615][ T25] __schedule (kernel/sched/core.c:5372 kernel/sched/core.c:6756)
> [ 997.060058][ T25] ? async_synchronize_cookie_domain (kernel/async.c:317 (discriminator 9))
> [ 997.070156][ T25] schedule (arch/x86/include/asm/preempt.h:26 kernel/sched/core.c:5865 kernel/sched/core.c:5885 kernel/sched/core.c:6834 kernel/sched/core.c:6848)
> [ 997.079936][ T25] async_synchronize_cookie_domain (kernel/async.c:317 (discriminator 9))
> [ 997.090893][ T25] ? do_wait_intr_irq (kernel/sched/wait.c:383)
> [ 997.109522][ T25] wait_for_initramfs (init/initramfs.c:767)
> [ 997.118460][ T25] populate_rootfs (init/initramfs.c:778)
> [ 997.126493][ T25] do_one_initcall (init/main.c:1266)
> [ 997.136390][ T25] ? do_header (init/initramfs.c:771)
> [ 997.147147][ T25] ? rdinit_setup (init/main.c:1312)
> [ 997.160654][ T25] ? rcu_is_watching (kernel/rcu/tree.c:738)
> [ 997.178488][ T25] do_initcalls (init/main.c:1327 init/main.c:1344)
> [ 997.195442][ T25] kernel_init_freeable (init/main.c:1579)
> [ 997.199167][ T25] ? rest_init (init/main.c:1458)
> [ 997.208072][ T25] kernel_init (init/main.c:1468)
> [ 997.218814][ T25] ret_from_fork (arch/x86/kernel/process.c:153)
> [ 997.225966][ T25] ? rest_init (init/main.c:1458)
> [ 997.231504][ T25] ret_from_fork_asm (arch/x86/entry/entry_32.S:737)
> [ 997.240527][ T25] entry_INT80_32 (arch/x86/entry/entry_32.S:942)
> [  997.318483][   T25]
> [  997.318483][   T25] Showing all locks held in the system:
> [  997.346428][   T25] 1 lock held by kworker/0:0/6:
> [  997.350161][   T25] 4 locks held by kworker/u4:0/9:
> [  997.396160][   T25] 1 lock held by khungtaskd/25:
> [ 997.399871][ T25] #0: 83f91ab0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks (include/linux/rcupdate.h:337 include/linux/rcupdate.h:849 kernel/locking/lockdep.c:6744)
> [  997.478673][   T25]
> [  997.501376][   T25] =============================================
> [  997.501376][   T25]
> [ 1161.445030][    C0] workqueue: psi_avgs_work hogged CPU for >10000us 11 times, consider switching to WQ_UNBOUND
> BUG: kernel hang in boot stage
> 
> 
> 
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20241225/202412251418.8e78094d-lkp@intel.com
> 
> 
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
> 
> 

Thanks.  Unfortunately, the issue does not reproduce for me when following these
commands.

The kernel does panic from not being able to find the rootfs, both before and
after.  That seems to be caused by the rootfs from the job script not being
available on the 01.org server, as indicated by the following output:

    /usr/bin/wget -q --timeout=3600 --tries=1 --local-encoding=UTF-8 https://download.01.org/0day-ci/lkp-qemu/osimage/pkg/quantal-i386-core.cgz/trinity-static-i386-x86_64-f93256fb_2019-08-28.cgz -N -P /home/e/.lkp/cache/osimage/pkg/quantal-i386-core.cgz
    Failed to download osimage/pkg/quantal-i386-core.cgz/trinity-static-i386-x86_64-f93256fb_2019-08-28.cgz
    cat: '': No such file or directory

It doesn't print the error information from wget, but I checked and it is HTTP
error 404 Not Found.  Thus, there seem to be bugs in lkp where (a) it links to a
non-existent rootfs, and (b) errors downloading the rootfs are not fatal.

Anyway, seeing as you disabled the x86 optimized CRC32 code:

> +# CONFIG_CRC32_IMPL_ARCH_PLUS_SLICEBY8 is not set
> +# CONFIG_CRC32_IMPL_ARCH_PLUS_SLICEBY1 is not set

... that code is not even running in the kernel.  So it is hard to see how this
commit could plausibly have caused this issue.

- Eric
