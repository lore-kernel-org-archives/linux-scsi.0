From: butao <butao@hisilicon.com>
Subject: [PATCH 2/3] scsi:ufs:add ufs node&reset property for hi3660
Date: Sat, 10 Jun 2017 09:20:58 +0800
Message-ID: <20170610012058.33422-1-butao@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:7806 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751595AbdFJBYW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jun 2017 21:24:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: guodong.xu@linaro.org, gengjianfeng@hisilicon.com, kongfei@hisilicon.com, suzhuangluan@hisilicon.com, steven.yujianfeng@hisilicon.com, zangleigang@hisilicon.com, butao@hisilicon.com

add ufs node for hi3660

Signed-off-by: Bu Tao <butao@hisilicon.com>
---
 arch/arm64/boot/dts/hisilicon/hi3660.dtsi | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 mode change 100644 => 100755 arch/arm64/boot/dts/hisilicon/hi3660.dtsi

diff --git a/arch/arm64/boot/dts/hisilicon/hi3660.dtsi b/arch/arm64/boot/dts/hisilicon/hi3660.dtsi
old mode 100644
new mode 100755
index 3983086bd67b..4ba9cec43d94
--- a/arch/arm64/boot/dts/hisilicon/hi3660.dtsi
+++ b/arch/arm64/boot/dts/hisilicon/hi3660.dtsi
@@ -141,6 +141,26 @@
 		#size-cells = <2>;
 		ranges;
 
+                ufs: ufs@ff3b0000 {
+                        compatible = "jedec,ufs-1.1", "hisilicon,hi3660-ufs";
+                        reg = <0x0 0xff3b0000 0x0 0x1000>,      /* 0: HCI standard */
+                              <0x0 0xff3b1000 0x0 0x1000>;      /* 1: UFS SYS CTRL */
+                        interrupt-parent = <&gic>;
+                        interrupts = <0 278 4>;
+                        clocks = <&crg_ctrl HI3660_CLK_GATE_UFSIO_REF>,
+                                 <&crg_ctrl HI3660_CLK_GATE_UFSPHY_CFG>;
+                        clock-names = "clk_ref", "clk_phy";
+                        freq-table-hz = <0 0>, <0 0>;
+                        resets = <&crg_rst 0x84 12>, 		/* offset: 0x84; bit: 12 */
+                                 <&crg_rst 0x84 7>; 		/* offset: 0x84; bit: 7  */
+                        reset-names = "rst", "assert";
+                        ufs-hi3660-use-rate-B;
+                        ufs-hi3660-broken-fastauto;
+                        ufs-hi3660-use-HS-GEAR3;
+                        ufs-hi3660-broken-clk-gate-bypass;
+                        status = "ok";
+                };
+
 		fixed_uart5: fixed_19_2M {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
-- 
2.11.GIT
