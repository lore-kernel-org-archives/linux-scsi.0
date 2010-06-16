From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 2/5]wireless:hostap_ap.c Fix warning: variable 'fc' set but not used
Date: Tue, 15 Jun 2010 22:33:51 -0700
Message-ID: <1276666434-11227-3-git-send-email-justinmattock@gmail.com>
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, "Justin P. Mattock" <justinmattock@gmail.com>
List-Id: linux-scsi@vger.kernel.org

The below patch fixes a warning message when compiling with gcc 4.6.0
  CC [M]  drivers/net/wireless/hostap/hostap_ap.o
drivers/net/wireless/hostap/hostap_ap.c: In function 'hostap_ap_tx_cb_assoc':
drivers/net/wireless/hostap/hostap_ap.c:691:6: warning: variable 'fc' set but not used

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/wireless/hostap/hostap_ap.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_ap.c b/drivers/net/wireless/hostap/hostap_ap.c
index 231dbd7..9cadaa2 100644
--- a/drivers/net/wireless/hostap/hostap_ap.c
+++ b/drivers/net/wireless/hostap/hostap_ap.c
@@ -688,7 +688,7 @@ static void hostap_ap_tx_cb_assoc(struct sk_buff *skb, int ok, void *data)
 	struct ap_data *ap = data;
 	struct net_device *dev = ap->local->dev;
 	struct ieee80211_hdr *hdr;
-	u16 fc, status;
+	u16 status;
 	__le16 *pos;
 	struct sta_info *sta = NULL;
 	char *txt = NULL;
@@ -699,7 +699,6 @@ static void hostap_ap_tx_cb_assoc(struct sk_buff *skb, int ok, void *data)
 	}
 
 	hdr = (struct ieee80211_hdr *) skb->data;
-	fc = le16_to_cpu(hdr->frame_control);
 	if ((!ieee80211_is_assoc_resp(hdr->frame_control) &&
 	     !ieee80211_is_reassoc_resp(hdr->frame_control)) ||
 	    skb->len < IEEE80211_MGMT_HDR_LEN + 4) {
-- 
1.7.1.rc1.21.gf3bd6
