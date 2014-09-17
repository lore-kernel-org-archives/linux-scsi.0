From: Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v4] scsi: ufs: add support of generic PHY framework in Qualcomm MSM chips
Date: Wed, 17 Sep 2014 15:27:43 -0700
Message-ID: <7CC13860-9AEB-4A97-9D12-DC0A8E8F27C0@codeaurora.org>
References: <1410970929-25544-1-git-send-email-ygardi@codeaurora.org> <000001cfd294$18e4e300$4aaea900$@codeaurora.org>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <000001cfd294$18e4e300$4aaea900$@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, noag@codeaurora.org, draviv@codeaurora.org, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kishon Vijay Abraham I <kishon@ti.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Grant Likely <grant.likely@linaro.org>, Raviv Shvili <rshvili@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Christoph Hellwig <hch@lst.de>, Sahitya Tummala <stummala@codeaurora.org>, "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On Sep 17, 2014, at 9:26 AM, Yaniv Gardi <ygardi@codeaurora.org> wrote:

> This change depends on draviv [PATCH v3] series of 16 changes that was
> already uploaded.
> Soon draviv will uploaded again as [PATCH v4] that contain 17 patches, and
> this change will be dependent on this serie,
> 
> Thanks,
> Yaniv
> 
> -----Original Message-----
> From: Yaniv Gardi [mailto:ygardi@codeaurora.org] 
> Sent: Wednesday, September 17, 2014 7:22 PM
> To: James.Bottomley@HansenPartnership.com; hch@infradead.org
> Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org;
> linux-arm-msm@vger.kernel.org; santoshsy@gmail.com;
> linux-scsi-owner@vger.kernel.org; subhashj@codeaurora.org;
> ygardi@codeaurora.org; noag@codeaurora.org; draviv@codeaurora.org; Rob
> Herring; Pawel Moll; Mark Rutland; Ian Campbell; Kumar Gala; Kishon Vijay
> Abraham I; Vinayak Holikatti; James E.J. Bottomley; Grant Likely; Raviv
> Shvili; Sujit Reddy Thumma; Christoph Hellwig; Sahitya Tummala; open
> list:OPEN FIRMWARE AND...
> Subject: [PATCH v4] scsi: ufs: add support of generic PHY framework in
> Qualcomm MSM chips
> 
> In this change we add support to the generic PHY framework.
> Two UFS phys are implemented:
> qmp-20nm and qmp-28nm.
> 
> Also, the files in this change implement the UFS HW (controller & PHY)
> specific behavior in Qualcomm chips.
> Relocation of a few header files is needed in order to expose routines
> and data structures between PHY driver and UFS driver
> 
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
> ---
> .../devicetree/bindings/phy/qcom-ufs-phy.txt       |  37 +
> drivers/phy/Makefile                               |   3 +
> drivers/phy/phy-qcom-ufs-qmp-20nm.c                | 259 ++++++
> drivers/phy/phy-qcom-ufs-qmp-20nm.h                | 216 +++++
> drivers/phy/phy-qcom-ufs-qmp-28nm.c                | 342 ++++++++
> drivers/phy/phy-qcom-ufs-qmp-28nm.h                | 738 ++++++++++++++++++
> drivers/phy/phy-qcom-ufs.c                         | 661 ++++++++++++++++
> drivers/scsi/ufs/Kconfig                           |  12 +
> drivers/scsi/ufs/Makefile                          |   1 +
> drivers/scsi/ufs/ufs-qcom.c                        | 866
> +++++++++++++++++++++
> drivers/scsi/ufs/ufs.h                             | 491 ------------
> drivers/scsi/ufs/ufshcd-pci.c                      |   2 +-
> drivers/scsi/ufs/ufshcd-pltfrm.c                   |   2 +-
> drivers/scsi/ufs/ufshcd.c                          |  14 +-
> drivers/scsi/ufs/ufshcd.h                          | 595 --------------
> drivers/scsi/ufs/unipro.h                          | 207 -----
> include/linux/phy/phy-qcom-ufs.h                   | 202 +++++
> include/linux/scsi/ufs/ufs-qcom.h                  | 156 ++++
> include/linux/scsi/ufs/ufs.h                       | 491 ++++++++++++
> include/linux/scsi/ufs/ufshcd.h                    | 635 +++++++++++++++
> include/linux/scsi/ufs/unipro.h                    | 207 +++++
> 21 files changed, 4840 insertions(+), 1297 deletions(-)
> create mode 100644 Documentation/devicetree/bindings/phy/qcom-ufs-phy.txt
> create mode 100644 drivers/phy/phy-qcom-ufs-qmp-20nm.c
> create mode 100644 drivers/phy/phy-qcom-ufs-qmp-20nm.h
> create mode 100644 drivers/phy/phy-qcom-ufs-qmp-28nm.c
> create mode 100644 drivers/phy/phy-qcom-ufs-qmp-28nm.h
> create mode 100644 drivers/phy/phy-qcom-ufs.c
> create mode 100644 drivers/scsi/ufs/ufs-qcom.c
> delete mode 100644 drivers/scsi/ufs/ufs.h
> delete mode 100644 drivers/scsi/ufs/ufshcd.h
> delete mode 100644 drivers/scsi/ufs/unipro.h
> create mode 100644 include/linux/phy/phy-qcom-ufs.h
> create mode 100644 include/linux/scsi/ufs/ufs-qcom.h
> create mode 100644 include/linux/scsi/ufs/ufs.h
> create mode 100644 include/linux/scsi/ufs/ufshcd.h
> create mode 100644 include/linux/scsi/ufs/unipro.h

Can you split this into multiple patches.  At least one that just moves the headers around without any other changes.  Than another that introduces the PHY code.  Will make it far easier to review.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
