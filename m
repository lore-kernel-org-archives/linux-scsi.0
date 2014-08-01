From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v5 2/3] arm64: Fix the csr-mask for APM X-Gene SoC AHCI SATA PHY clock DTS node.
Date: Fri,  1 Aug 2014 23:07:17 +0530
Message-ID: <1406914638-24721-3-git-send-email-stripathi@apm.com>
References: <1406914638-24721-1-git-send-email-stripathi@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:45968 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754442AbaHARis (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Aug 2014 13:38:48 -0400
In-Reply-To: <1406914638-24721-1-git-send-email-stripathi@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>

The value of the csr-mask of the SATA PHY clock DTS node has a
wrong value resulting a kernel panic as the clock/reset is not
proper for the PHY of the SATA host controller 1. This patch
fixes the correct csr-mask value of the SATA PHY clock DTS node
for the SATA Host controller 1.

As the 'ok' is the default status of a device tree node, this patch
removes the status of the PHY clock node of SATA Host Controller 1.
The status of the clock node is handled from the firmware based on
the controller enabled/disabled by the user.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 arch/arm64/boot/dts/apm-storm.dtsi | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
index 40aa96c..1bdaeda 100644
--- a/arch/arm64/boot/dts/apm-storm.dtsi
+++ b/arch/arm64/boot/dts/apm-storm.dtsi
@@ -184,9 +184,8 @@
 				reg = <0x0 0x1f21c000 0x0 0x1000>;
 				reg-names = "csr-reg";
 				clock-output-names = "sataphy1clk";
-				status = "disabled";
 				csr-offset = <0x4>;
-				csr-mask = <0x00>;
+				csr-mask = <0x3a>;
 				enable-offset = <0x0>;
 				enable-mask = <0x06>;
 			};
@@ -198,7 +197,6 @@
 				reg = <0x0 0x1f22c000 0x0 0x1000>;
 				reg-names = "csr-reg";
 				clock-output-names = "sataphy2clk";
-				status = "ok";
 				csr-offset = <0x4>;
 				csr-mask = <0x3a>;
 				enable-offset = <0x0>;
@@ -212,7 +210,6 @@
 				reg = <0x0 0x1f23c000 0x0 0x1000>;
 				reg-names = "csr-reg";
 				clock-output-names = "sataphy3clk";
-				status = "ok";
 				csr-offset = <0x4>;
 				csr-mask = <0x3a>;
 				enable-offset = <0x0>;
--
1.8.2.1

