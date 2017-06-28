From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Permanently change thin provisioning method from user space?
Date: Tue, 27 Jun 2017 21:05:52 -0400
Message-ID: <yq1shikzztb.fsf@oracle.com>
References: <CAA91j0VCH06Xfk2Hx6ooDnd4+9+Sv1Z+2TY7MmQmgKLoiB0=+A@mail.gmail.com>
        <1498597291.10198.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16740 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753585AbdF1BGA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jun 2017 21:06:00 -0400
In-Reply-To: <1498597291.10198.21.camel@localhost.localdomain> (Ewan
        D. Milne's message of "Tue, 27 Jun 2017 17:01:31 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: Andrei Borzenkov <arvidjaar@gmail.com>, linux-scsi@vger.kernel.org


Ewan,

> sd_fops->revalidate_disk() will cause the properties that cause the
> provisioning_mode to be evaluated to be re-read, and sd_config_discard()
> to set the determined mode.  We might want to re-think this, since the
> user overrode what was probed earlier.  However, we might also want to
> automatically handle the storage capabilities changing, so I'm not
> sure.

The intent was for people to use udev to override things. But I guess we
could entertain introducing a flag to distinguish between detected and
configured state.

> My reading of SBC-4r13 6.6.4 is that a WRITE SAME(16) w/UNMAP has
> a length limited by the MAXIMUM WRITE SAME LENGTH, and that is what
> sd.c implements, but I'm suspicious that the array treated a WRITE SAME(16)
> w/UNMAP of 2097152 blocks as an UNMAP and failed it w/ILLEGAL COMMAND,
> INVALID FIELD IN CDB.

Ugh :(

-- 
Martin K. Petersen	Oracle Linux Engineering
