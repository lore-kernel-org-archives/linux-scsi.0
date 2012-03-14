From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci PATCH v3 4/4] isci: enable BCN in sci_port_add_phy()
Date: Wed, 14 Mar 2012 00:14:08 -0700
Message-ID: <20120314071408.7223.84179.stgit@dwillia2-linux.jf.intel.com>
References: <20120314071312.7223.10946.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120314071312.7223.10946.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Maciej Trela <maciej.trela@intel.com>, linux-ide@vger.kernel.org, Richard Boyd <richard.g.boyd@intel.com>
List-Id: linux-scsi@vger.kernel.org

From: Maciej Trela <maciej.trela@intel.com>

Ensure we enable receiving BCN's from the
hardware when adding phy to isci_port.
Otherwise if we get BCN before the port is
created we won't see any BCN

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
Reported-by: Richard Boyd <richard.g.boyd@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/port.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
index 6ef4bd9..0a3aec1 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -1199,6 +1199,8 @@ enum sci_status sci_port_add_phy(struct isci_port *iport,
 	enum sci_status status;
 	enum sci_port_states state;
 
+	sci_port_bcn_enable(iport);
+
 	state = iport->sm.current_state_id;
 	switch (state) {
 	case SCI_PORT_STOPPED: {

