From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 0/2] mpt3sas: Reference counting fixes from for-next mpt2sas
Date: Sun, 30 Aug 2015 07:54:37 +0000
Message-ID: <1440921279-9973-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:33187 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbbH3IAc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Aug 2015 04:00:32 -0400
Received: by obcid8 with SMTP id id8so22855465obc.0
        for <linux-scsi@vger.kernel.org>; Sun, 30 Aug 2015 01:00:31 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Calvin Owens <calvinowens@fb.com>, Christoph Hellwig <hch@infradead.org>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, "MPT-FusionLinux.pdl" <MPT-FusionLinux.pdl@avagotech.com>, kernel-team <kernel-team@fb.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi all,

This series is a mpt3sas LLD forward port of Calvin Owens' for-next
reference counting bugfix series for mpt2sas LLD code.

His latest patch series can be found here:

[PATCH v4 0/2] Fixes for memory corruption in mpt2sas
http://marc.info/?l=linux-scsi&m=143951695904115&w=2

The differences between mpt2sas + mpt3sas in this area are very
small, and the changes are required to address a class of long
standing NULL pointer dereference bugs through-out both LLDs.

With Calvin's changes in place for mpt3sas, the original NULL
pointer dereference OOPsen during probe with a failed HDD appear
to be resolved, and so far no new regressions have been reported
with -v1 series code.

The -v1 series code for mpt3sas has been tested on v3.14.47 with
40x SAS3008 HBAs, with three preceeding upstream mpt3sas patches:

4dc06fd mpt3sas: delay scsi_add_host call to work with scsi-mq
35b6236 mpt3sas: combine fw_event_work and its event_data
62c4da4 mpt3sas: correct scsi_{target,device} hostdata allocation

Please review.

--nab

-v2 changes:
  - Fix _scsih_block_io_device() v4.3-rc0 brekage
  - Fix mpt3sas_transport_port_add() v4.3-rc0 breakage

Nicholas Bellinger (2):
  mpt3sas: Refcount sas_device objects and fix unsafe list usage
  mpt3sas: Refcount fw_events and fix unsafe list usage

 drivers/scsi/mpt3sas/mpt3sas_base.h      |  25 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 595 ++++++++++++++++++++++---------
 drivers/scsi/mpt3sas/mpt3sas_transport.c |  18 +-
 3 files changed, 458 insertions(+), 180 deletions(-)

-- 
1.9.1

