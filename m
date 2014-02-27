From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v12 3/4] PHY: add APM X-Gene SoC 15Gbps Multi-purpose PHY driver
Date: Thu, 27 Feb 2014 12:02:32 -0800
Message-ID: <CAPw-ZTkB9LhWmw3+WMTF-0tAwGibugxmCAu2VgNkmGaa6ojJUA@mail.gmail.com>
References: <1393524848-8207-1-git-send-email-lho@apm.com>
	<1393524848-8207-2-git-send-email-lho@apm.com>
	<1393524848-8207-3-git-send-email-lho@apm.com>
	<1393524848-8207-4-git-send-email-lho@apm.com>
	<20140227190259.GC4862@saruman.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20140227190259.GC4862@saruman.home>
Sender: linux-ide-owner@vger.kernel.org
To: balbi@ti.com
Cc: Kishon Vijay Abraham I <kishon@ti.com>, Tejun Heo <tj@kernel.org>, Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Don Dutile <ddutile@redhat.com>, Jon Masters <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hi Balbi,

>> +/*
>> + * This function is used to configure the PHY to operation as either SATA Gen1
>> + * or Gen2 speed.
>> + */
>> +static void xgene_phy_sata_force_gen(struct xgene_phy_ctx *ctx,
>> +                                  int lane, int gen)
>
> why do you need to *force* the generation ? Is this because of some
> silicon errata ? It almost seems like this should be done through link
> negotiation between both link partners.

You can call this as an errata or limitation of the underlying PHY IP.
As start, the PHY is configured with auto neg up to 6Gbps (or Gen3
speed). After link up, we will know whether it is Gen1 (1.5Gbps), Gen2
(3.0Gbps), or Gen3 (6.0Gbps). In order to ensure reliability, the PHY
needs to be configured at specified speed. For this reason and after
link up, the PHY is re-trained for the linked up speed.

-Loc
