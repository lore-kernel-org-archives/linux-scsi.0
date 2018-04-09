From: Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH 1/1] scsi/ufs: qcom: Don't enable PHY_QCOM_UFS by default
Date: Mon, 9 Apr 2018 13:09:04 -0700
Message-ID: <20180409200904.GL453@tuxbook-pro>
References: <20180409132404.20876-1-vivek.gautam@codeaurora.org>
 <20180409165127.GK453@tuxbook-pro>
 <2588cd12-081a-5fad-7ef5-af78b18168eb@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2588cd12-081a-5fad-7ef5-af78b18168eb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Gautam <vivek.gautam@codeaurora.org>
Cc: martin.petersen@oracle.com, kishon@ti.com, jejb@linux.vnet.ibm.com, subhashj@codeaurora.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon 09 Apr 10:38 PDT 2018, Vivek Gautam wrote:
> On 4/9/2018 10:21 PM, Bjorn Andersson wrote:
> > On Mon 09 Apr 06:24 PDT 2018, Vivek Gautam wrote:
[..]
> > > diff --git a/include/linux/phy/phy-qcom-ufs.h b/include/linux/phy/phy-qcom-ufs.h
> > > index 0a2c18a9771d..1388c2a2965e 100644
> > > --- a/include/linux/phy/phy-qcom-ufs.h
> > > +++ b/include/linux/phy/phy-qcom-ufs.h
> > > @@ -31,8 +31,21 @@ void ufs_qcom_phy_enable_dev_ref_clk(struct phy *phy);
> > >    */
> > >   void ufs_qcom_phy_disable_dev_ref_clk(struct phy *phy);
> > > +#if IS_ENABLED(CONFIG_PHY_QCOM_UFS)
> > >   int ufs_qcom_phy_set_tx_lane_enable(struct phy *phy, u32 tx_lanes);
> > >   void ufs_qcom_phy_save_controller_version(struct phy *phy,
> > > -			u8 major, u16 minor, u16 step);
> > > +					  u8 major, u16 minor, u16 step);
> > > +#else
> > > +static inline int ufs_qcom_phy_set_tx_lane_enable(struct phy *phy, u32 tx_lanes)
> > > +{
> > > +	return -ENOSYS;
> > > +}
> > > +
> > > +static inline void ufs_qcom_phy_save_controller_version(struct phy *phy,
> > > +							u8 major, u16 minor,
> > > +							u16 step)
> > > +{
> > > +}
> > > +#endif /* PHY_QCOM_UFS */
> > What's the timeline for getting rid of the references to these
> > functions? I presume that code depending on these being here will
> > compile but won't actually work?
> 
> Yes, these inline definitions are just to keep ufs-qcom happy with the
> direct
> calls that it makes to these functions.
> As you would know these couple of functions are just used by the 20nm phy.
> However, we don't have any platform yet in the upstream that enables this
> phy.
> I am hoping that we will eventually get rid of these functions when we
> further
> clean up ufs-qcom driver.
> 

I see, but that means that we're calling this function with a struct phy
that might not be a struct ufs_qcom_phy and as such a defconfig with
both enabled will have undefined outcome for the migrated phys.

In particular we do expect that the same kernel will boot on db820c and
sdm845-mtp, so we will have to enable support for the 14nm & 20nm phy
driver (and we don't want random crashes because someone happened to
enable it).


So either we add the 10nm support to the existing driver or I think we
should migrate, at least, the 14nm support to the QMP driver (and mark
the remaining 20nm BROKEN for now).

Regardless of the path chosen this should be cleaned up to the point
where all three phys are supported.

Regards,
Bjorn
