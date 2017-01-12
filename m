From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] scsi: megaraid_sas: Dynamic Raid Map Changes for SAS3.5
 Generic Megaraid Controllers
Date: Thu, 12 Jan 2017 22:09:16 +0300
Message-ID: <20170112190916.GA14816@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40469 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750819AbdALTJg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2017 14:09:36 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sasikumar.pc@broadcom.com, Tomas Henzl <thenzl@redhat.com>
Cc: megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org

Hello Sasikumar Chandrasekaran,

The patch d889344e4e59: "scsi: megaraid_sas: Dynamic Raid Map Changes
for SAS3.5 Generic Megaraid Controllers" from Jan 10, 2017, leads to
the following static checker warning:

	drivers/scsi/megaraid/megaraid_sas_fusion.c:2043 megasas_build_ldio_fusion()
	warn: curly braces intended?

drivers/scsi/megaraid/megaraid_sas_fusion.c
  2020                  if (instance->is_ventura) {
  2021                          if (io_info.isRead) {
  2022                                  if ((raid->cpuAffinity.pdRead.cpu0) &&
  2023                                          (raid->cpuAffinity.pdRead.cpu1))
  2024                                          praid_context->raid_context_g35.routing_flags.bits.cpu_sel
  2025                                          = MR_RAID_CTX_CPUSEL_FCFS;
  2026                                  else if (raid->cpuAffinity.pdRead.cpu1)
  2027                                          praid_context->raid_context_g35.routing_flags.bits.cpu_sel
  2028                                          = MR_RAID_CTX_CPUSEL_1;
  2029                                  else
  2030                                          praid_context->raid_context_g35.routing_flags.bits.cpu_sel
  2031                                          = MR_RAID_CTX_CPUSEL_0;
  2032                          } else {
  2033                          if ((raid->cpuAffinity.pdWrite.cpu0)
  2034                          && (raid->cpuAffinity.pdWrite.cpu1))
  2035                                  praid_context->raid_context_g35.routing_flags.bits.cpu_sel
  2036                                          = MR_RAID_CTX_CPUSEL_FCFS;
  2037                                  else if (raid->cpuAffinity.pdWrite.cpu1)
  2038                                          praid_context->raid_context_g35.routing_flags.bits.cpu_sel
  2039                                          = MR_RAID_CTX_CPUSEL_1;
  2040                                  else
  2041                                          praid_context->raid_context_g35.routing_flags.bits.cpu_sel
  2042                                          = MR_RAID_CTX_CPUSEL_0;
  2043                                  if (praid_context->raid_context_g35.routing_flags.bits.sld) {
  2044                                          praid_context->raid_context_g35.raid_flags
  2045                                          = (MR_RAID_FLAGS_IO_SUB_TYPE_CACHE_BYPASS
  2046                                          << MR_RAID_CTX_RAID_FLAGS_IO_SUB_TYPE_SHIFT);
  2047                                  }
  2048                          }
  2049                  }
  2050          } else {

Wow...  You guys are probably already discussed this code, but I'm not
on the linux-scsi list.  Do we have a process issue where we are merging
code that we shouldn't be?  What's going on here?

regards,
dan carpenter
