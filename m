From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [RFC v2 20/21] tcm: Add Kbuild and Kconfig for drivers/target,
 Documentation/target/tcm_mod_builder.py
Date: Tue, 5 Oct 2010 16:38:20 +0900
Message-ID: <20101005163323P.fujita.tomonori@lab.ntt.co.jp>
References: <1285195906-11804-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1285195906-11804-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu, hch@lst.de, hare@suse.de, James.Bottomley@suse.de, axboe@kernel.dk, bharrosh@panasas.com
List-Id: linux-scsi@vger.kernel.org

On Wed, 22 Sep 2010 15:51:46 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Add TCM Kbuild and Kconfig files and update drivers/ to pick up drivers/target.
> Add Docmentation/target/ for tcm_mod_builder.py script for generating new
> TCM v4 fabric modules functional ConfigFS skeletons.
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  Documentation/target/tcm_mod_builder.py  | 1039 ++++++++++++++++++++++++++++++
>  Documentation/target/tcm_mod_builder.txt |  138 ++++
>  drivers/Kconfig                          |    2 +
>  drivers/Makefile                         |    1 +
>  drivers/target/Kbuild                    |   27 +
>  drivers/target/Kconfig                   |   34 +
>  6 files changed, 1241 insertions(+), 0 deletions(-)
>  create mode 100755 Documentation/target/tcm_mod_builder.py
>  create mode 100644 Documentation/target/tcm_mod_builder.txt
>  create mode 100644 drivers/target/Kbuild
>  create mode 100644 drivers/target/Kconfig

> +++ b/Documentation/target/tcm_mod_builder.txt
> @@ -0,0 +1,138 @@
> +>>>>>>>>>> The TCM v4 fabric module script generator <<<<<<<<<<
> +
> +Greetings all,
> +
> +This document is intended to be a mini-HOWTO for using the tcm_mod_builder.py
> +script to generate a brand new functional TCM v4 fabric .ko module of your very own,
> +that once built can be immediately be loaded to start access the new TCM/ConfigFS
> +fabric skeleton, by simplying using:
> +
> +	modprobe $TCM_NEW_MOD
> +	mkdir -p /sys/kernel/config/target/$TCM_NEW_MOD
> +
> +This script will create a new drivers/target/$TCM_NEW_MOD/, and will do the following
> +
> +	*) Generate new API callers for drivers/target/target_core_fabric_configs.c logic
> +	   ->make_nodeacl(), ->drop_nodeacl(), ->make_tpg(), ->drop_tpg()
> +	   ->make_wwn(), ->drop_wwn().  These are created into $TCM_NEW_MOD/$TCM_NEW_MOD_configfs.c
> +	*) Generate basic infrastructure for loading/unloading LKMs and TCM/ConfigFS fabric module
> +	   using a skeleton struct target_core_fabric_ops API template.
> +	*) Based on user defined T10 Proto_Ident for the new fabric module being built,
> +	   the TransportID / Initiator and Target WWPN related handlers for
> +	   SPC-3 persistent reservation are automatically generated in $TCM_NEW_MOD/$TCM_NEW_MOD_fabric.c
> +	   using drivers/target/target_core_fabric_lib.c logic.
> +	*) NOP API calls for all other Data I/O path and fabric dependent attribute logic
> +	   in $TCM_NEW_MOD/$TCM_NEW_MOD_fabric.c
> +
> +So far the generation of new functional ConfigFS skeletons supports for FC,
> +SAS and iSCSI proto_idents, which is defined at the top of tcm_mod_builder.py:main().
> +Once proto_ident is selected in main(), and the handful of other global variables at top
> +of tcm_mod_builder.py are correct, actually running the script looks like:
> +
> +target:/mnt/sdb/lio-core-2.6.git/Documentation/target# ./tcm_mod_builder.py 
> +Writing file:
> +/mnt/sdb/lio-core-2.6.git/drivers/target/tcm_nab5000/tcm_nab5000_base.h
> +Using tcm_mod_scan_fabric_ops:

I thought that I can use this to write IBM vscsi target driver but I
got:

fujita@rose:~/git/linux-next/Documentation/target$ ./tcm_mod_builder.py
Creating fabric_mod_dir: /mnt/sdb/lio-core-2.6.git/drivers/target/tcm_nab5000
Traceback (most recent call last):
  File "./tcm_mod_builder.py", line 1039, in <module>
    main()
  File "./tcm_mod_builder.py", line 1028, in main
    tcm_mod_create_module_subdir()
  File "./tcm_mod_builder.py", line 38, in tcm_mod_create_module_subdir
    ret = os.mkdir(fabric_mod_dir)
OSError: [Errno 2] No such file or directory: '/mnt/sdb/lio-core-2.6.git/drivers/target/tcm_nab5000'


And looks like tcm_dir isn't configurable.
