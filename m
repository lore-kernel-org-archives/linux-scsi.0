From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [RFC] results of endianness review of qla2xxx
Date: Wed, 16 Apr 2008 06:54:58 +0100
Message-ID: <20080416055458.GC27459@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:57765 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbYDPFzA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Apr 2008 01:55:00 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.68 #1 (Red Hat Linux))
	id 1Jm0bi-0002zb-T8
	for linux-scsi@vger.kernel.org; Wed, 16 Apr 2008 06:54:58 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Assorted endianness problems and uncertain places:

1) In qla24xx_nvram_config():
	    nv->nvram_version < __constant_cpu_to_le16(ICB_VERSION)) {
comparisons work better in host-endian...

2) Same function:
	icb->login_timeout = cpu_to_le16(nv->login_timeout);
both are little-endian

3) qla24xx_login_fabric():
	lg->vp_index = cpu_to_le16(ha->vp_idx);
->vp_index is 8bit, ha->vp_idx is host-endian (and small)

4) qla24xx_fabric_logout():
same story.

5) qla24xx_report_id_acquisition():
	if (rptid_entry->entry_status != 0)
		return;
	if (rptid_entry->entry_status != __constant_cpu_to_le16(CS_COMPLETE))
		return;
For one thing, ->entry_status is 8bit.  For another, CS_COMPLETE is 0, so this
pair of checks looks bogus anyway.

6) Same function:
		vp_idx = LSB(rptid_entry->vp_idx);
->vp_idx is little-endian 16bit; LSB expects host-endian
		if (MSB(rptid_entry->vp_idx) == 1)
... and so does MSB.

7) qla2x00_async_event():
		handles[0] = le32_to_cpu((uint32_t)((mb[2] << 16) | mb[1]));
		...
		handles[0] = le32_to_cpu((uint32_t)((mb[2] << 16) | mb[1]));
		handles[1] = le32_to_cpu(
		    ((uint32_t)(RD_MAILBOX_REG(ha, reg, 7) << 16)) |
and then those values are passed to qla2x00_process_completed_request() which
expects a host-endian (and uses it as index in array, among other things).

8) qla2x00_fdmi_rpa():
	max_frame_size = IS_FWI2_CAPABLE(ha) ?
		(uint32_t) icb24->frame_payload_size:
		(uint32_t) ha->init_cb->frame_payload_size;
	eiter->a.max_frame_size = cpu_to_be32(max_frame_size);
and AFAICS ->frame_payload_size is little-endian 16bit.

9) qla2x00_clear_nvram_protection():
        wprot_old = cpu_to_le16(qla2x00_get_nvram_word(ha, ha->nvram_base));
	stat = qla2x00_write_nvram_word_tmo(ha, ha->nvram_base,
		    __constant_cpu_to_le16(0x1234), 100000);
	wprot = cpu_to_le16(qla2x00_get_nvram_word(ha, ha->nvram_base));
	if (stat != QLA_SUCCESS || wprot != 0x1234) {
Odd, since qla2x00_get_nvram_word() returns a host-endian and 
qla2x00_write_nvram_word_tmo() expects one (this stuff is bit-banging
16bit values through).

10)
typedef struct vf_id {
        uint16_t id : 12;
	uint16_t priority : 4;
} vf_id_t;

and

typedef struct vf_hopct {
	uint16_t reserved : 8;
	uint16_t hopct : 8;
} vf_hopct_t;

Buggered, since (a) vf_id is severely endian-dependent and (b) both will happily
get padding on e.g. arm; since they are embedded into hardware-shared structures,
extra 16 bits tacked onto each is Not Good(tm).

11) The same changeset that had introduced vf_id has a related oddity:

-       uint8_t reserved_4[32];
+       uint16_t flags;
+       struct vf_id    id;
+       uint16_t reserved_4;
+       struct vf_hopct  hopct;
+       uint8_t reserved_5[8];

had been bogus - 2 + 2 + 2 + 2 + 8 != 32; 16 bytes got cut.
