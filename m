From: Rajendra Nayak <rnayak@codeaurora.org>
Subject: [RFC v2 00/11] DVFS in the OPP core
Date: Wed, 20 Mar 2019 15:19:07 +0530
Message-ID: <20190320094918.20234-1-rnayak@codeaurora.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org, linux-serial@vger.kernel.org, linux-spi@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-scsi@vger.kernel.org, swboyd@chromium.org, ulf.hansson@linaro.org, viresh.kumar@linaro.org, dianders@chromium.org, rafael@kernel.org, Rajendra Nayak <rnayak@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

This is a v2 of the RFC posted earlier by Stephen Boyd [1]

As part of v2 I still follow the same approach of dev_pm_opp_set_rate()
API using clk framework to round the frequency passed and making it
accept 0 as a valid frequency indicating the frequency isn't required
anymore. It just has a few more drivers converted to use this approach
like dsi/dpu and ufs.
ufs demonstrates the case of having to handle multiple power domains, one
of which is scalable.

The patches are based on 5.1-rc1 and depend on some ufs fixes I posted
earlier [2] and a DT patch to include the rpmpd header [3]

[1] https://lkml.org/lkml/2019/1/28/2086
[2] https://lkml.org/lkml/2019/3/8/70
[3] https://lkml.org/lkml/2019/3/20/120

Rajendra Nayak (10):
  OPP: Make dev_pm_opp_set_rate() with freq=0 as valid
  tty: serial: qcom_geni_serial: Use OPP API to set clk/perf state
  spi: spi-geni-qcom: Use OPP API to set clk/perf state
  arm64: dts: sdm845: Add OPP table for all qup devices
  scsi: ufs: Add support to manage multiple power domains in
    ufshcd-pltfrm
  scsi: ufs: Add support for specifying OPP tables in DT
  arm64: dts: sdm845: Add ufs opps and power-domains
  drm/msm/dpu: Use OPP API to set clk/perf state
  drm/msm: dsi: Use OPP API to set clk/perf state
  arm64: dts: sdm845: Add DSI and MDP OPP tables and power-domains

Stephen Boyd (1):
  OPP: Don't overwrite rounded clk rate

 arch/arm64/boot/dts/qcom/sdm845.dtsi          | 194 +++++++++++++++++-
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c |   7 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c       |   9 +
 drivers/gpu/drm/msm/dsi/dsi.h                 |   2 +
 drivers/gpu/drm/msm/dsi/dsi_cfg.c             |   4 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c            |  88 +++++++-
 drivers/opp/core.c                            |  26 ++-
 drivers/scsi/ufs/ufshcd-pltfrm.c              |  52 ++++-
 drivers/scsi/ufs/ufshcd.c                     |  21 +-
 drivers/scsi/ufs/ufshcd.h                     |   3 +
 drivers/spi/spi-geni-qcom.c                   |  14 +-
 drivers/tty/serial/qcom_geni_serial.c         |  15 +-
 12 files changed, 406 insertions(+), 29 deletions(-)

-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
