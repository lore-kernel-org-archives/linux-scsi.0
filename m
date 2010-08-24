From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16901] New: Security problem in the FTP URL for obtaining
 QLogic Fibre Channel HBA firmware
Date: Tue, 24 Aug 2010 13:31:58 GMT
Message-ID: <bug-16901-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56549 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073Ab0HXNb7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Aug 2010 09:31:59 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o7ODVwAO026215
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 24 Aug 2010 13:31:58 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16901

           Summary: Security problem in the FTP URL for obtaining QLogic
                    Fibre Channel HBA firmware
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.35.3
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: QLOGIC QLA2XXX
        AssignedTo: scsi_drivers-qla2xxx@kernel-bugs.osdl.org
        ReportedBy: plamen@tonev.net
        Regression: No


Created an attachment (id=27801)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=27801)
Proof that firmware files can be replaces with malicious ones

The qla2xxx driver in the latest stable 2.6.35.3 prints dangerous URL
(ftp.qlogic.com) for obtaining new firmware for their adapters.

From: linux-2.6.35.3/drivers/scsi/qla2xxx/qla_init.c
---- quote -----
#define QLA_FW_URL "ftp://ftp.qlogic.com/outgoing/linux/firmware/"

int
qla2x00_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
{
        int     rval;
        int     i, fragment;
        uint16_t *wcode, *fwcode;
        uint32_t risc_addr, risc_size, fwclen, wlen, *seg;
        struct fw_blob *blob;
        struct qla_hw_data *ha = vha->hw;
        struct req_que *req = ha->req_q_map[0];

        /* Load firmware blob. */
        blob = qla2x00_request_firmware(vha);
        if (!blob) {
                qla_printk(KERN_ERR, ha, "Firmware image unavailable.\n");
                qla_printk(KERN_ERR, ha, "Firmware images can be retrieved "
                    "from: " QLA_FW_URL ".\n");
                return QLA_FUNCTION_FAILED;
        }

---- end quote -----

  It is dangerous to give the users this URL for obtaining new firmware images,
because this QLogic FTP site isn't secure at all and everyone anonymously can
exchange the original firmware .bin files with their own files.
The outgoing/linux/firmware folder is read-only and files cannot be replaced,
or created new ones. The folder itself cannot be renamed too, but everyone can
rename linux folder to linux2 for example, then create a new linux folder with
firmware inside and put their own files instead of the 'official' ones from
QLogic.
  It can be done easy and you can see the attached screenshot for proof.
Until better security is implemented on this FTP (or better place for storing
firmware releases is found) I recommend to print a warning to all users of this
driver about security problems with the QLogic FTP site.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
