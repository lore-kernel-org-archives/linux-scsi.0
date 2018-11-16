From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 3/3] block: add back command filter modification via sysfs
Date: Fri, 16 Nov 2018 08:00:35 +0100
Message-ID: <44a2a5d0-1802-e6b0-b6e2-5930eed37e21@redhat.com>
References: <1541867733-7836-1-git-send-email-pbonzini@redhat.com>
 <1541867733-7836-4-git-send-email-pbonzini@redhat.com>
 <1542347164.100259.32.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1542347164.100259.32.camel@acm.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

On 16/11/18 06:46, Bart Van Assche wrote:
> I do not know any application for which it would be useful to allow some but
> not all of these commands. With the proposed interface however users will
> have to examine all SCSI opcodes and for each opcode they will have to decide
> whether or not it should be allowed. Additionally, for opcodes like 7fh that
> represent multiple commands, users will have to decide whether they want to
> allow all these commands or none. That's why I think that filtering SCSI
> commands based on their CDB is an unfortunate choice. Would it be sufficient
> for the use cases you are looking at to group SCSI commands as follows and to
> enable/disable these commands per group:
> * SCSI command that read information from the medium (e.g. READ) or from the
>   controller (e.g. READ CAPACITY).
> * SCSI commands that modify information on the medium (e.g. WRITE).
> * SCSI commands that modify controller settings (e.g. MODE SELECT or SET
>   TARGET PORT GROUPS).

And also:

* all SCSI commands (e.g. write microcode, vendor specific commands).

It would.  However, it would be impossible to do this without making the
filter depend on the SCSI device type.  This has been rejected in 2012.

Paolo
