From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] efct: fix compilation warning about atomic_t usage
Date: Wed, 15 Mar 2017 21:58:23 +0000
Message-ID: <1489615061.2660.11.camel@sandisk.com>
References: <20170315222743.00004630@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:21353 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751277AbdCOV6b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2017 17:58:31 -0400
In-Reply-To: <20170315222743.00004630@gmx.de>
Content-Language: en-US
Content-ID: <1EAD09973259A147AF74CFB23412AB39@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "james.smart@broadcom.com" <james.smart@broadcom.com>, "herbszt@gmx.de" <herbszt@gmx.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 2017-03-15 at 22:27 +0100, Sebastian Herbszt wrote:
> Use kref_read() instead of accessing the counter inside a kref.

Hello Sebastian,

It is a good habit for a patch that fixes a compilation warning to mention
the warning message that has been fixed in the patch description.

> @@ -3821,7 +3821,7 @@ efct_hw_io_free(struct efct_hw_s *hw, struct efct_h=
w_io_s *io)
>  uint8_t
>  efct_hw_io_inuse(struct efct_hw_s *hw, struct efct_hw_io_s *io)
>  {
> -	return (atomic_read(&io->ref.refcount) > 0);
> +	return (kref_read(&io->ref) > 0);
>  }

A minor style comment: checkpatch should have told you that parentheses are
not necessary in a return statement ("return is not a function, parentheses
are not required").

Otherwise this patch looks fine to me.

Bart.=
