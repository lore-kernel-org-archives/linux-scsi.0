From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 188061] On quad port QLE2564 can't add in target only 2 ports
Date: Mon, 21 Nov 2016 17:38:04 +0000
Message-ID: <bug-188061-11613-pdNgejUnD7@https.bugzilla.kernel.org/>
References: <bug-188061-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750807AbcKURiI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Nov 2016 12:38:08 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 85EB0201C0
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2016 17:38:06 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 982092015A
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2016 17:38:04 +0000 (UTC)
In-Reply-To: <bug-188061-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=188061

--- Comment #4 from Anthony <anthony.bloodoff@gmail.com> ---
>From rtslib (naa wwn must start with 1 or 2 or 5):

def normalize_wwn(wwn_types, wwn):
    '''
    Take a WWN as given by the user and convert it to a standard text
    representation.

    Returns (normalized_wwn, wwn_type), or exception if invalid wwn.
    '''
    wwn_test = {
    'free': lambda wwn: True,
    'iqn': lambda wwn: \
        re.match("iqn\.[0-9]{4}-[0-1][0-9]\..*\..*", wwn) \
        and not re.search(' ', wwn) \
        and not re.search('_', wwn),
    'naa': lambda wwn: re.match("naa\.[125][0-9a-fA-F]{15}$", wwn),
    'eui': lambda wwn: re.match("eui\.[0-9a-f]{16}$", wwn),
    'ib': lambda wwn: re.match("ib\.[0-9a-f]{32}$", wwn),
    'unit_serial': lambda wwn: \
        re.match("[0-9A-Fa-f]{8}(-[0-9A-Fa-f]{4}){3}-[0-9A-Fa-f]{12}$", wwn),
    }

    for wwn_type in wwn_types:
        clean_wwn = _cleanse_wwn(wwn_type, wwn)
        found_type = wwn_test[wwn_type](clean_wwn)
        if found_type:
            break
    else:
        raise RTSLibError("WWN not valid as: %s" % ", ".join(wwn_types))

    return (clean_wwn, wwn_type)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
