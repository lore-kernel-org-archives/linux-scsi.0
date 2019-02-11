From: Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: [PATCH RFC v2] fcoe: make use of fip_mode enum complete
Date: Mon, 11 Feb 2019 10:53:06 -0700
Message-ID: <20190211175306.GA16698@archlinux-ryzen>
References: <20190211170751.1687-1-sedat.dilek@credativ.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190211170751.1687-1-sedat.dilek@credativ.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Sedat Dilek <sedat.dilek@credativ.de>
Cc: QLogic-Storage-Upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jth@kernel.org>, QLogic-Storage-Upstream@cavium.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Sedat Dilek <sedat.dilek@gmail.com>, Lukas Bulwahn <lukas.bulwahn@gmail.com>, Nick Desaulniers <ndesaulniers@google.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 11, 2019 at 06:07:51PM +0100, Sedat Dilek wrote:
> From: Sedat Dilek <sedat.dilek@gmail.com>
> 
> commit 1917d42d14b7 ("fcoe: use enum for fip_mode") introduces a separate
> enum for the fip_mode that shall be used during initialisation handling
> until it is passed to fcoe_ctrl_link_up to set the initial fip_state.
> That change was incomplete and gcc quietly converted in various places
> between the fip_mode and the fip_state enum values with implicit enum
> conversions, which fortunately cannot cause any issues in the actual
> code's execution.
> 
> clang however warns about these implicit enum conversions in the scsi
> drivers. This commit consolidates the use of the two enums, guided by
> clang's enum-conversion warnings.
> 
> This commit now completes the use of the fip_mode:
> It expects and uses fip_mode in {bnx2fc,fcoe}_interface_create and
> fcoe_ctlr_init, and it explicitly converts from fip_mode to fip_state
> only at the single point in fcoe_ctlr_link_up.
> 
> To eliminate that adding or removing values from fip_mode or fip_state enum
> break the right mapping of values, all fip_mode values are assigned to
> their fip_state counterparts.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/151
> Fixes: 1917d42d14b7 ("fcoe: use enum for fip_mode")
> Reported-by: Dmitry Golovin "Twisted Pair in my Hair" <dima@golovin.in>
> CC: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> CC: Nick Desaulniers <ndesaulniers@google.com>
> CC: Nathan Chancellor <natechancellor@gmail.com>
> CC: Hannes Reinecke <hare@suse.com>
> Suggested-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
> 
> [ v2:
>    - Based on the original patch by Lukas Bulwahn
>    - Suggestion by Johannes T. [1] required some changes:
>      + s/case FIP_ST_VMMP_START/case FIP_ST_V*N*MP_START
>      + s/return FIP_ST_AUTO/return FIP_MODE_AUTO
>    - Add Link to ClangBuiltLinux issue #151
>    - S-o-b line later when there is an OK from the FCoE maintainers
> 
> NOTE: Compile-tested against Linux-v5.0-rc6 with LLVM/Clang from Git with
>       experimental asm-goto support via executing:
>       $ make V=1 CC=clang-9 HOSTCC=clang-9 drivers/scsi/fcoe/
> 
> [1] https://marc.info/?l=linux-scsi&m=154745527612152&w=2
> 
>   -dileks ]
> 
>  drivers/scsi/bnx2fc/bnx2fc_fcoe.c  |  2 +-
>  drivers/scsi/fcoe/fcoe.c           |  2 +-
>  drivers/scsi/fcoe/fcoe_ctlr.c      |  4 ++--
>  drivers/scsi/fcoe/fcoe_transport.c |  2 +-
>  drivers/scsi/qedf/qedf_main.c      |  2 +-
>  include/scsi/libfcoe.h             | 22 ++++++++++++++++++++--
>  6 files changed, 26 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> index 2e4e7159ebf9..a75e74ad1698 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> @@ -1438,7 +1438,7 @@ static struct bnx2fc_hba *bnx2fc_hba_create(struct cnic_dev *cnic)
>  static struct bnx2fc_interface *
>  bnx2fc_interface_create(struct bnx2fc_hba *hba,
>  			struct net_device *netdev,
> -			enum fip_state fip_mode)
> +			enum fip_mode fip_mode)
>  {
>  	struct fcoe_ctlr_device *ctlr_dev;
>  	struct bnx2fc_interface *interface;
> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> index cd19be3f3405..8ba8862d3292 100644
> --- a/drivers/scsi/fcoe/fcoe.c
> +++ b/drivers/scsi/fcoe/fcoe.c
> @@ -389,7 +389,7 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
>   * Returns: pointer to a struct fcoe_interface or NULL on error
>   */
>  static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev,
> -						    enum fip_state fip_mode)
> +						    enum fip_mode fip_mode)
>  {
>  	struct fcoe_ctlr_device *ctlr_dev;
>  	struct fcoe_ctlr *ctlr;
> diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
> index 54da3166da8d..a52d3ad94876 100644
> --- a/drivers/scsi/fcoe/fcoe_ctlr.c
> +++ b/drivers/scsi/fcoe/fcoe_ctlr.c
> @@ -147,7 +147,7 @@ static void fcoe_ctlr_map_dest(struct fcoe_ctlr *fip)
>   * fcoe_ctlr_init() - Initialize the FCoE Controller instance
>   * @fip: The FCoE controller to initialize
>   */
> -void fcoe_ctlr_init(struct fcoe_ctlr *fip, enum fip_state mode)
> +void fcoe_ctlr_init(struct fcoe_ctlr *fip, enum fip_mode mode)
>  {
>  	fcoe_ctlr_set_state(fip, FIP_ST_LINK_WAIT);
>  	fip->mode = mode;
> @@ -454,7 +454,7 @@ void fcoe_ctlr_link_up(struct fcoe_ctlr *fip)
>  		mutex_unlock(&fip->ctlr_mutex);
>  		fc_linkup(fip->lp);
>  	} else if (fip->state == FIP_ST_LINK_WAIT) {
> -		fcoe_ctlr_set_state(fip, fip->mode);
> +		fcoe_ctlr_set_state(fip, (enum fip_state) fip->mode);
>  		switch (fip->mode) {
>  		default:
>  			LIBFCOE_FIP_DBG(fip, "invalid mode %d\n", fip->mode);
> diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
> index f4909cd206d3..b381ab066b9c 100644
> --- a/drivers/scsi/fcoe/fcoe_transport.c
> +++ b/drivers/scsi/fcoe/fcoe_transport.c
> @@ -873,7 +873,7 @@ static int fcoe_transport_create(const char *buffer,
>  	int rc = -ENODEV;
>  	struct net_device *netdev = NULL;
>  	struct fcoe_transport *ft = NULL;
> -	enum fip_state fip_mode = (enum fip_state)(long)kp->arg;
> +	enum fip_mode fip_mode = (enum fip_mode)(long)kp->arg;
>  
>  	mutex_lock(&ft_mutex);
>  
> diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
> index 9bbc19fc190b..9f9431a4cc0e 100644
> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
> @@ -1418,7 +1418,7 @@ static struct libfc_function_template qedf_lport_template = {
>  
>  static void qedf_fcoe_ctlr_setup(struct qedf_ctx *qedf)
>  {
> -	fcoe_ctlr_init(&qedf->ctlr, FIP_ST_AUTO);
> +	fcoe_ctlr_init(&qedf->ctlr, FIP_MODE_AUTO);
>  
>  	qedf->ctlr.send = qedf_fip_send;
>  	qedf->ctlr.get_src_addr = qedf_get_src_mac;
> diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
> index cb8a273732cf..38bb5b798a81 100644
> --- a/include/scsi/libfcoe.h
> +++ b/include/scsi/libfcoe.h
> @@ -79,12 +79,30 @@ enum fip_state {
>   * It must not change after fcoe_ctlr_init() sets it.
>   */
>  enum fip_mode {
> -	FIP_MODE_AUTO = FIP_ST_AUTO,
> +	FIP_MODE_AUTO,
>  	FIP_MODE_NON_FIP,
>  	FIP_MODE_FABRIC,
>  	FIP_MODE_VN2VN,
>  };
>  
> +static inline enum fip_mode fip_state_to_mode(enum fip_state state)

Hi Sedat,

You added this function but you didn't use it anywhere. I think Johannes
wanted this function to be used instead of all of the places where
you/Lukas changed the cast or raw enum value so that the conversion
still happens but it's explicit.

I think we'll need two versions of this function, one that goes from
state to mode and another that goes from mode to state as both
conversions happen (x86 allyesconfig build in drivers/scsi/):

drivers/scsi/fcoe/fcoe.c:2225:39: warning: implicit conversion from enumeration type 'enum fip_mode' to different enumeration type 'enum fip_state' [-Wenum-conversion]
drivers/scsi/bnx2fc/bnx2fc_fcoe.c:2363:51: warning: implicit conversion from enumeration type 'enum fip_mode' to different enumeration type 'enum fip_state' [-Wenum-conversion]
drivers/scsi/fnic/fnic_main.c:774:31: warning: implicit conversion from enumeration type 'enum fip_mode' to different enumeration type 'enum fip_state' [-Wenum-conversion]
drivers/scsi/fnic/fnic_main.c:785:31: warning: implicit conversion from enumeration type 'enum fip_mode' to different enumeration type 'enum fip_state' [-Wenum-conversion]
drivers/scsi/fcoe/fcoe_ctlr.c:153:14: warning: implicit conversion from enumeration type 'enum fip_state' to different enumeration type 'enum fip_mode' [-Wenum-conversion]
drivers/scsi/fcoe/fcoe_ctlr.c:457:33: warning: implicit conversion from enumeration type 'enum fip_mode' to different enumeration type 'enum fip_state' [-Wenum-conversion]

Let me know what you think,
Nathan

> +{
> +	switch (state) {
> +	case FIP_ST_AUTO:
> +		return FIP_MODE_AUTO;
> +	case FIP_ST_NON_FIP:
> +		return FIP_MODE_NON_FIP;
> +	case FIP_ST_ENABLED:
> +		return FIP_MODE_FABRIC;
> +	case FIP_ST_VNMP_START:
> +		return FIP_MODE_VN2VN;
> +	default:
> +		WARN(1, "Invalid FIP state");
> +	}
> +
> +	return FIP_MODE_AUTO;
> +}
> +
>  /**
>   * struct fcoe_ctlr - FCoE Controller and FIP state
>   * @state:	   internal FIP state for network link and FIP or non-FIP mode.
> @@ -250,7 +268,7 @@ struct fcoe_rport {
>  };
>  
>  /* FIP API functions */
> -void fcoe_ctlr_init(struct fcoe_ctlr *, enum fip_state);
> +void fcoe_ctlr_init(struct fcoe_ctlr *, enum fip_mode);
>  void fcoe_ctlr_destroy(struct fcoe_ctlr *);
>  void fcoe_ctlr_link_up(struct fcoe_ctlr *);
>  int fcoe_ctlr_link_down(struct fcoe_ctlr *);
> -- 
> 2.20.1
> 
