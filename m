From: Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH v3 0/3] Fix UFS and devfreq interaction
Date: Thu, 17 May 2018 23:26:35 -0700
Message-ID: <20180518062638.31777-1-bjorn.andersson@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Andy Gross <andy.gross@linaro.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-soc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

With the introduction of f1d981eaecf8 ("PM / devfreq: Use the available min/max
frequency") the UFS host controller driver (UFSHCD) stopped probing for
platforms that supports frequency scaling, e.g. all modern Qualcomm platforms.

The cause of this was UFSHCD's reliance of not registering any frequencies and
then being called by devfreq to switch between the frequencies 0 and UINT_MAX.

The devfreq code implies that the client is able to pass the frequency table,
instead of relying on opp tables, but as concluded after v1 this is not
compliant with devfreq cooling, which will enable and disable opp entries in
order to limit the valid frequencies. So instead the UFSHCD driver is modified
to read the freq-table and register the first clock's two rates as the two
available opp levels.


This follows the first patch which facilitates the implementation of this in a
clean fashion, and removes the kernel panic which previously happened when
devfreq initialization failed.


With this UFS is once again functional on the db820c, and is needed to get UFS
working on SDM845 (both tested).

Added in v3 is the dts patch for Andy to introduce UFS in msm8996 and db820c,
now that it finally works again.

Bjorn Andersson (3):
  scsi: ufs: Extract devfreq registration
  scsi: ufs: Use freq table with devfreq
  arm64: dts: qcom: msm8996: Add ufs related nodes

 arch/arm64/boot/dts/qcom/apq8096-db820c.dtsi |  8 ++
 arch/arm64/boot/dts/qcom/msm8996.dtsi        | 85 ++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c                    | 76 +++++++++++++----
 3 files changed, 154 insertions(+), 15 deletions(-)

-- 
2.17.0
