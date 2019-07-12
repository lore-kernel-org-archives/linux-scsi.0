From: Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 0/2] scsi: ufs: Fix broken hba->outstanding_tasks
Date: Fri, 12 Jul 2019 12:44:14 +0800
Message-ID: <1562906656-27154-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com, pedrom.sousa@synopsys.com
Cc: marc.w.gonzalez@free.fr, andy.teng@mediatek.com, chun-hung.wu@mediatek.com, kuohong.wang@mediatek.com, evgreen@chromium.org, linux-mediatek@lists.infradead.org, peter.wang@mediatek.com, matthias.bgg@gmail.com, Stanley Chu <stanley.chu@mediatek.com>, linux-arm-kernel@lists.infradead.org, beanhuo@micron.com
List-Id: linux-scsi@vger.kernel.org

Q3VycmVudGx5IGJpdHMgaW4gaGJhLT5vdXRzdGFuZGluZ190YXNrcyBhcmUgY2xlYXJlZCBvbmx5
IGFmdGVyIHRoZWlyCmNvcnJlc3BvbmRpbmcgdGFzayBtYW5hZ2VtZW50IGNvbW1hbmRzIGFyZSBz
dWNjZXNzZnVsbHkgZG9uZSBieQpfX3Vmc2hjZF9pc3N1ZV90bV9jbWQoKS4KCklmIHRpbWVvdXQg
aGFwcGVucyBpbiBhIHRhc2sgbWFuYWdlbWVudCBjb21tYW5kLCBpdHMgY29ycmVzcG9uZGluZwpi
aXQgaW4gaGJhLT5vdXRzdGFuZGluZ190YXNrcyB3aWxsIG5vdCBiZSBjbGVhcmVkIHVudGlsIG5l
eHQgdGFzawptYW5hZ2VtZW50IGNvbW1hbmQgd2l0aCB0aGUgc2FtZSB0YWcgdXNlZCBzdWNjZXNz
ZnVsbHkgZmluaXNoZXMu4oCnCgpUaGlzIGlzIHdyb25nIGFuZCBjYW4gbGVhZCB0byBzb21lIGlz
c3VlcywgbGlrZSBwb3dlciBjb25zdW1wdG9uIGlzc3VlLgpGb3IgZXhhbXBsZSwgdWZzaGNkX3Jl
bGVhc2UoKSBhbmQgdWZzaGNkX2dhdGVfd29yaygpIHdpbGwgZG8gbm90aGluZwppZiBoYmEtPm91
dHN0YW5kaW5nX3Rhc2tzIGlzIG5vdCB6ZXJvIGV2ZW4gaWYgYm90aCBVRlMgaG9zdCBhbmQgZGV2
aWNlcwphcmUgYWN0dWFsbHkgaWRsZS4KCkJlY2F1c2UgZXJyb3IgaGFuZGxpbmcgZmxvdywgaS5l
LiwgdWZzaGNkX3Jlc2V0X2FuZF9yZXN0b3JlKCksIHdpbGwgYmUKdHJpZ2dlcmVkIGFmdGVyIGFu
eSB0YXNrIG1hbmFnZW1lbnQgY29tbWFuZCB0aW1lcyBvdXQsIHdlIGZpeCB0aGlzIGJ5CmNsZWFy
aW5nIGNvcnJlc3BvbmRpbmcgaGJhLT5vdXRzdGFuZGluZ190YXNrcyBiaXRzIGR1cmluZyB0aGlz
IGZsb3cuClRvIGFjaGlldmUgdGhpcywgd2UgbmVlZCBhIG1hc2sgdG8gdHJhY2sgdGltZWQtb3V0
IGNvbW1hbmRzIGFuZCB0aHVzCmVycm9yIGhhbmRsaW5nIGZsb3cgY2FuIGNsZWFyIHRoZWlyIHRh
Z3Mgc3BlY2lmaWNhbGx5LgoKU3RhbmxleSBDaHUgKDIpOgogIHNjc2k6IHVmczogTWFrZSBuZXcg
ZnVuY3Rpb24gZm9yIGNsZWFyaW5nIG91dHN0YW5kaW5nIHRhc2sgYml0cwogIHNjc2k6IHVmczog
Rml4IGJyb2tlbiBoYmEtPm91dHN0YW5kaW5nX3Rhc2tzCgogZHJpdmVycy9zY3NpL3Vmcy91ZnNo
Y2QuYyB8IDQ5ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLQogZHJpdmVy
cy9zY3NpL3Vmcy91ZnNoY2QuaCB8ICAxICsKIDIgZmlsZXMgY2hhbmdlZCwgNDMgaW5zZXJ0aW9u
cygrKSwgNyBkZWxldGlvbnMoLSkKCi0tIAoyLjE4LjAKCgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwpsaW51eC1hcm0ta2VybmVsIG1haWxpbmcgbGlzdAps
aW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmcKaHR0cDovL2xpc3RzLmluZnJhZGVh
ZC5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1hcm0ta2VybmVsCg==
