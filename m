From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] fcoe: make use of fip_mode enum complete
Date: Mon, 14 Jan 2019 09:40:55 +0100
Message-ID: <bd956ee5-3265-34bd-bbbc-aac5d4bea83d@suse.de>
References: <20190112053427.35696-1-lukas.bulwahn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190112053427.35696-1-lukas.bulwahn@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Lukas Bulwahn <lukas.bulwahn@gmail.com>, linux-scsi@vger.kernel.org
Cc: QLogic-Storage-Upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jth@kernel.org>, QLogic-Storage-Upstream@cavium.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12/01/2019 06:34, Lukas Bulwahn wrote:
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

Hi Lukas,

I have to admit, don't like this patch too much.

While it looks technically correct (I haven't tested it yet) it, it
mixes fip_state and fip_mode even more, which I think is bad for the
readability of the code flow.

Maybe you could add a conversion function for it?

Something like (untested):
static inline enum fip_mode fip_state_to_mode(enum fip_state state)
{
	switch (state) {
	case FIP_ST_AUTO:
		return FIP_MODE_AUTO;
	case FIP_ST_NON_FIP:
		return FIP_MODE_NON_FIP;
	case FIP_ST_ENABLED:
		return FIP_MODE_FABRIC;
	case FIP_ST_VMMP_START:
		return FIP_MODE_VN2VN;
	default:
		WARN(1, "Invalid FIP state");
	}

	return FIP_ST_AUTO;
}

Byte,
	Johannes
-- 
Johannes Thumshirn                            SUSE Labs Filesystems
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
