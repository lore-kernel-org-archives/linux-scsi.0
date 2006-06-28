From: Brian King <brking@us.ibm.com>
Subject: [PATCH 0/4] libata: Support SATA attached via SAS
Date: Wed, 28 Jun 2006 08:29:47 -0500
Message-ID: <44A2844B.7010002@us.ibm.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jeff,

Here are the remaining patches to my patchset to allow SAS HBAs to
use libata to control attached SATA devices. You had two concerns
in the last round of patches, which I have tried to address here.

1. Per device max command length checking
   - You were concerned with adding an additional check to the
     hot path. To address this I moved the check so that it is
     now only made for SAS users, which is really the only users that
     need it since existing SATA users have host->max_cmd_len
     protecting them.

2. Add ata_host_flags
   - You thought there might be a need to carry some cross port state.
     To resolve this I added a new API: ata_host_set_init. Callers
     of ata_sas_port_alloc must now pass their host_set pointer as the
     first argument. This removes the need for the patch you objected to
     and allows for a cross port state if needed.



-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
