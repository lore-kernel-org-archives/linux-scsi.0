From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v3 0/3] hpsa update
Date: Tue, 22 Dec 2015 10:36:29 -0600
Message-ID: <20151222163508.16655.97012.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:54807 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932095AbbLVQhT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Dec 2015 11:37:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

These patches are based on Linus's tree

The changes are:
 - correct missing changes from snprintf to scnprintf
   in path_info_show by Rasmus Villemoes
 - fix reported bus for SAS transport devices
 - add in enclosure information

Changes from initial upload
 - added short patch description for patch
   hpsa-add-enclosure-connection-box-bay-information
 - kept hpsa-change-hba-controller-to-bus-0 the same to
   minimize changes.

Changes from V1
 - modified add box and bay information for enclosure
   devices based on Matthew R. Ochs review.
   - moved memory allocation lower in function
     hpsa_get_enclosure_info
   - removed memset on a kzalloc'ed buffer
   - do not fill out enclosure info on tape and medium
     changer devices.
   - changed hpsa_get_enclosure_info to type void.

Changes from V2
 - Added missing '{' that kdiff3 seemed to have removed.
   sorry about that.

---

Don Brace (3):
      hpsa: fix path_info_show
      hpsa: change SAS transport devices to bus 0.
      hpsa: add box and bay information for enclosure devices


 drivers/scsi/hpsa.c     |  117 ++++++++++++++++++++++++++++++++++++++++++-----
 drivers/scsi/hpsa.h     |    2 -
 drivers/scsi/hpsa_cmd.h |   13 +++++
 3 files changed, 119 insertions(+), 13 deletions(-)

--
Signature
