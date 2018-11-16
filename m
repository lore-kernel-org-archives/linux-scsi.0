From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 3/3] block: add back command filter modification via
 sysfs
Date: Fri, 16 Nov 2018 06:42:45 -0800
Message-ID: <1542379365.100259.34.camel@acm.org>
References: <1541867733-7836-1-git-send-email-pbonzini@redhat.com>
         <1541867733-7836-4-git-send-email-pbonzini@redhat.com>
         <1542347164.100259.32.camel@acm.org>
         <44a2a5d0-1802-e6b0-b6e2-5930eed37e21@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <44a2a5d0-1802-e6b0-b6e2-5930eed37e21@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2018-11-16 at 08:00 +-0100, Paolo Bonzini wrote:
+AD4 On 16/11/18 06:46, Bart Van Assche wrote:
+AD4 +AD4 I do not know any application for which it would be useful to allow some but
+AD4 +AD4 not all of these commands. With the proposed interface however users will
+AD4 +AD4 have to examine all SCSI opcodes and for each opcode they will have to decide
+AD4 +AD4 whether or not it should be allowed. Additionally, for opcodes like 7fh that
+AD4 +AD4 represent multiple commands, users will have to decide whether they want to
+AD4 +AD4 allow all these commands or none. That's why I think that filtering SCSI
+AD4 +AD4 commands based on their CDB is an unfortunate choice. Would it be sufficient
+AD4 +AD4 for the use cases you are looking at to group SCSI commands as follows and to
+AD4 +AD4 enable/disable these commands per group:
+AD4 +AD4 +ACo SCSI command that read information from the medium (e.g. READ) or from the
+AD4 +AD4   controller (e.g. READ CAPACITY).
+AD4 +AD4 +ACo SCSI commands that modify information on the medium (e.g. WRITE).
+AD4 +AD4 +ACo SCSI commands that modify controller settings (e.g. MODE SELECT or SET
+AD4 +AD4   TARGET PORT GROUPS).
+AD4 
+AD4 And also:
+AD4 
+AD4 +ACo all SCSI commands (e.g. write microcode, vendor specific commands).
+AD4 
+AD4 It would.  However, it would be impossible to do this without making the
+AD4 filter depend on the SCSI device type.  This has been rejected in 2012.

Do you have a link available to that discussion? Since the meaning of several
SCSI opcodes depends on the SCSI device type, I don't see how we can avoid
making filtering dependent on the SCSI device type.

Bart.
