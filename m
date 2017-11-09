From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v3] scsi: require CAP_SYS_ADMIN to write to procfs interface
Date: Thu, 09 Nov 2017 15:40:18 -0600
Message-ID: <87inejdtbx.fsf@xmission.com>
References: <20171105025635.10843-1-asarai@suse.de>
        <b3bcff37-d77d-4dc6-ba83-7dddcb51a703@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <b3bcff37-d77d-4dc6-ba83-7dddcb51a703@suse.de> (Aleksa Sarai's
        message of "Sun, 5 Nov 2017 15:02:10 +1100")
Sender: stable-owner@vger.kernel.org
To: Aleksa Sarai <asarai@suse.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, Valentin Rothberg <vrothberg@suse.com>, cyphar@cyphar.com, stable@vger.kernel.org, greg@kroah.com
List-Id: linux-scsi@vger.kernel.org

Aleksa Sarai <asarai@suse.de> writes:

> On 11/05/2017 01:56 PM, Aleksa Sarai wrote:
>> Previously, the only capability effectively required to operate on the
>> /proc/scsi interface was CAP_DAC_OVERRIDE (or for some other files,
>> having an fsuid of GLOBAL_ROOT_UID was enough). This means that
>> semi-privileged processes could interfere with core components of a
>> system (such as causing a DoS by removing the underlying SCSI device of
>> the host's / mount).
>
> An alternative to this patch would be to make the open(2) call fail, if you try
> to open it write-only or read-write. Not sure which would be preferred (should
> it be possible to pass /proc/scsi/scsi to a semi-privileged process to write
> to?).

Making open fail is very much the preferred solution.

Testing for permission on write can be avoided by finding a suid root
application whose error output acts like a suid cat.

The best current practice for adding this kind of permission check is to
add the check in open.  For some older use cases where we made this
mistake we had to maintian a check during write to avoid breaking
userspace.  But as this check is new there is no reason to add a check
anywhere except in open.

Eric
