From: Sasikumar PC <sasikumar.pc@broadcom.com>
Subject: RE: [bug report] scsi: megaraid_sas: Dynamic Raid Map Changes for
 SAS3.5 Generic Megaraid Controllers
Date: Fri, 13 Jan 2017 14:52:47 -0500
Message-ID: <1c88ee657aaea5bf1e48f0d49c722794@mail.gmail.com>
References: <20170112190916.GA14816@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:38020 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750789AbdAMTwu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2017 14:52:50 -0500
Received: by mail-wm0-f47.google.com with SMTP id r144so85982280wme.1
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2017 11:52:49 -0800 (PST)
In-Reply-To: <20170112190916.GA14816@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, Kiran Kumar Kasturi <kiran-kumar.kasturi@broadcom.com>, Christopher Owens <christopher.owens@broadcom.com>, Tomas Henzl <thenzl@redhat.com>

Hi Dan,

I will fix the static checker warning

Thanks
sasi

-----Original Message-----
From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
Sent: Thursday, January 12, 2017 2:09 PM
To: sasikumar.pc@broadcom.com; Tomas Henzl
Cc: megaraidlinux.pdl@broadcom.com; linux-scsi@vger.kernel.org
Subject: [bug report] scsi: megaraid_sas: Dynamic Raid Map Changes for
SAS3.5 Generic Megaraid Controllers

Hello Sasikumar Chandrasekaran,

The patch d889344e4e59: "scsi: megaraid_sas: Dynamic Raid Map Changes for
SAS3.5 Generic Megaraid Controllers" from Jan 10, 2017, leads to the
following static checker warning:

	drivers/scsi/megaraid/megaraid_sas_fusion.c:2043
megasas_build_ldio_fusion()
	warn: curly braces intended?

drivers/scsi/megaraid/megaraid_sas_fusion.c
  2020                  if (instance->is_ventura) {
  2021                          if (io_info.isRead) {
  2022                                  if
((raid->cpuAffinity.pdRead.cpu0) &&
  2023
(raid->cpuAffinity.pdRead.cpu1))
  2024
praid_context->raid_context_g35.routing_flags.bits.cpu_sel
  2025                                          = MR_RAID_CTX_CPUSEL_FCFS;
  2026                                  else if
(raid->cpuAffinity.pdRead.cpu1)
  2027
praid_context->raid_context_g35.routing_flags.bits.cpu_sel
  2028                                          = MR_RAID_CTX_CPUSEL_1;
  2029                                  else
  2030
praid_context->raid_context_g35.routing_flags.bits.cpu_sel
  2031                                          = MR_RAID_CTX_CPUSEL_0;
  2032                          } else {
  2033                          if ((raid->cpuAffinity.pdWrite.cpu0)
  2034                          && (raid->cpuAffinity.pdWrite.cpu1))
  2035
praid_context->raid_context_g35.routing_flags.bits.cpu_sel
  2036                                          = MR_RAID_CTX_CPUSEL_FCFS;
  2037                                  else if
(raid->cpuAffinity.pdWrite.cpu1)
  2038
praid_context->raid_context_g35.routing_flags.bits.cpu_sel
  2039                                          = MR_RAID_CTX_CPUSEL_1;
  2040                                  else
  2041
praid_context->raid_context_g35.routing_flags.bits.cpu_sel
  2042                                          = MR_RAID_CTX_CPUSEL_0;
  2043                                  if
(praid_context->raid_context_g35.routing_flags.bits.sld) {
  2044
praid_context->raid_context_g35.raid_flags
  2045                                          =
(MR_RAID_FLAGS_IO_SUB_TYPE_CACHE_BYPASS
  2046                                          <<
MR_RAID_CTX_RAID_FLAGS_IO_SUB_TYPE_SHIFT);
  2047                                  }
  2048                          }
  2049                  }
  2050          } else {

Wow...  You guys are probably already discussed this code, but I'm not on
the linux-scsi list.  Do we have a process issue where we are merging code
that we shouldn't be?  What's going on here?

regards,
dan carpenter
