From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 0/2] mpt3sas: Reference counting fixes from in-flight mpt2sas
Date: Wed, 26 Aug 2015 04:09:42 +0000
Message-ID: <1440562184-23945-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Calvin Owens <calvinowens@fb.com>, Christoph Hellwig <hch@infradead.org>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, "MPT-FusionLinux.pdl" <MPT-FusionLinux.pdl@avagotech.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi James & Co,

This series is a mpt3sas forward port of Calvin Owens' in-flight
reference counting bugfixes for mpt2sas LLD code here:

[PATCH v4 0/2] Fixes for memory corruption in mpt2sas
http://marc.info/?l=linux-scsi&m=143951695904115&w=2

The differences between mpt2sas + mpt3sas in this area are very,
very small, and is required to address a NULL pointer dereference
OOPsen in _scsih_probe_sas() -> mpt3sas_transport_port_add() ->
sas_port_add_phy() that I've been hitting occasionally on boot
during initial LUN scan.

So far this code has been tested on v3.14.47 with a small cluster
using SAS3008 HBAs plus a few preceeding upstream mpt3sas patches
so these patches apply cleanly, and with the changes in place the
original OOPsen appears to be resolved.

This patch series is cut atop v4.2-rc1 code, and barring any
objections from Avago folks et al., should be considered along
with Calvin's mpt2sas patch set for v4.3-rc1 code.

Thank you,

--nab

Nicholas Bellinger (2):
  mpt3sas: Refcount sas_device objects and fix unsafe list usage
  mpt3sas: Refcount fw_events and fix unsafe list usage

 drivers/scsi/mpt3sas/mpt3sas_base.h      |  23 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 592 ++++++++++++++++++++++---------
 drivers/scsi/mpt3sas/mpt3sas_transport.c |  12 +-
 3 files changed, 449 insertions(+), 178 deletions(-)

-- 
1.9.1
